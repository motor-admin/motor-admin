# frozen_string_literal: true

module Motor
  module DefineArModels
    EXCLUDE_TABLES = Set.new(
      %w[
        active_storage_blobs
        active_storage_variant_records
        motor_admin_user_roles
        motor_admin_users
        motor_alert_locks
        motor_alerts
        motor_dashboards
        motor_encrypted_configs
        motor_forms
        motor_resources
        motor_roles
        motor_taggable_tags
        motor_tags
        motor_api_configs
        motor_note_tag_tags
        motor_note_tags
        motor_notes
        motor_notifications
        motor_reminders
        active_storage_attachments
        ar_internal_metadata
        motor_audits
        motor_configs
        motor_queries
        schema_migrations
      ]
    ).freeze

    DEFINED_MODELS = ActiveSupport::HashWithIndifferentAccess.new
    TABLE_INDEXES_CACHE = ActiveSupport::HashWithIndifferentAccess.new
    ENUM_TYPE_VALUES_CACHE = ActiveSupport::HashWithIndifferentAccess.new

    TIMESTAMP_COLUMNS = [
      *ResourceRecord.timestamp_attributes_for_create,
      *ResourceRecord.timestamp_attributes_for_update
    ].freeze

    DEFINED_CLASS_CONNECTION_URLS_STORE = ActiveSupport::HashWithIndifferentAccess.new

    DEFINED_CLASS_SCHEMA_MD5_STORE = ActiveSupport::HashWithIndifferentAccess.new

    RUBY_CONSTANTS = Set.new(Object.constants.map(&:to_s)).freeze

    PG_SELECT_TABLES_QUERY = <<~SQL.squish
      select schemaname, tablename from pg_tables
      where schemaname NOT IN ('pg_catalog', 'information_schema')
    SQL

    PG_SELECT_SCHEMA_MD5 = <<~SQL.squish
      SELECT md5(string_agg(t::text, '')::text) FROM information_schema.columns as t WHERE table_schema IN (:schema)
    SQL

    MYSQL_SELECT_SCHEMA_MD5 = <<~SQL.squish
      SELECT * FROM information_schema.columns WHERE table_schema IN (:schema)
    SQL

    module_function

    def call(base_class)
      schema_md5 = fetch_schemas_md5(base_class.connection)

      tables = load_tables(base_class.connection)

      clear_models(base_class) if schema_md5 != DEFINED_CLASS_SCHEMA_MD5_STORE[base_class.name]

      DEFINED_MODELS[base_class.name] ||= {}

      define_models(tables, base_class).each do |model|
        next unless model.table_exists?

        configure_defined_model(model, base_class)
      end

      DEFINED_CLASS_SCHEMA_MD5_STORE[base_class.name] = schema_md5

      base_class
    end

    def defined_models_schema_md5
      Digest::MD5.hexdigest(DEFINED_CLASS_SCHEMA_MD5_STORE.values.join)
    end

    def clear_models(base_class)
      models = DEFINED_MODELS[base_class.name]

      return if models.blank?

      base_class.connection.schema_cache.clear!

      base_constant = base_class.name.include?('::') ? base_class.name.demodulize.safe_constantize : Object

      models.each_value { |klass| base_constant.send(:remove_const, klass.name.demodulize) }

      DEFINED_MODELS.delete(base_class.name)
    end

    # rubocop:disable Metrics/AbcSize
    def define_models(tables, base_class)
      tables.filter_map do |name|
        next if EXCLUDE_TABLES.include?(name)

        table_class_name = name.underscore.tr(' ', '_').classify

        class_name = if base_class == ::ResourceRecord
                       "#{'Db' if RUBY_CONSTANTS.include?(class_name)}#{table_class_name}"
                     else
                       [base_class.name.demodulize, table_class_name].join('::')
                     end

        klass = class_name.safe_constantize

        next if klass && ActiveRecord::Base.descendants.include?(klass)

        model = Class.new(base_class)
        model.table_name = name
        model.ignored_columns += (model.column_names.map(&:to_sym).intersection(base_class.instance_methods) - [:id])

        DEFINED_MODELS[base_class.name][name] = model

        set_model_constant(base_class, class_name, model)
      end
    end
    # rubocop:enable Metrics/AbcSize

    def configure_defined_model(model, base_class)
      assign_primary_key(model)
      define_model_validators(model)
      define_model_reflections(model, base_class)
      define_model_many_to_many(model) if join_table_model?(model)

      model
    end

    def set_model_constant(base_class, class_name, model)
      if class_name.safe_constantize
        Object.const_set("#{class_name}Record", model)
      else
        Object.const_set(class_name, model)
      end
    rescue NameError
      base_module   = base_class.name.demodulize.safe_constantize
      base_module ||= Object.const_set(base_class.name.demodulize, Module.new)

      base_module.const_set(class_name.demodulize, model)
    end

    def assign_primary_key(model)
      return if model.primary_key

      indexes = fetch_table_indexes(model)

      primary_key_column =
        model.columns.find do |column|
          next true if column.name == 'id'
          next if column.null

          indexes.find { |index| index.unique && index.columns == [column.name] }
        end

      return unless primary_key_column

      model.primary_key = primary_key_column.name
    end

    def define_model_validators(model)
      define_presence_validators(model)
      define_enum_validators(model)
    end

    def define_enum_validators(model)
      return if model.connection.class.to_s != 'ActiveRecord::ConnectionAdapters::PostgreSQLAdapter'

      model.columns.each do |column|
        next if column.type != :enum

        cache_key = connection_url_hash(model) + column.sql_type

        ENUM_TYPE_VALUES_CACHE[cache_key] ||=
          model.pluck(Arel.sql("unnest(enum_range(NULL::#{column.sql_type}))::text")).uniq

        model.validates_inclusion_of column.name.to_sym, in: ENUM_TYPE_VALUES_CACHE[cache_key]
      end
    end

    def define_presence_validators(model)
      required_columns =
        model.columns.reject do |column|
          column.name == model.primary_key ||
            column.null ||
            column.default ||
            column.default_function ||
            column.type == :boolean ||
            column.name.in?(TIMESTAMP_COLUMNS)
        end

      return if required_columns.blank?

      model.validates_presence_of(required_columns.map(&:name))
    end

    # rubocop:disable Metrics/AbcSize
    def define_model_many_to_many(model)
      ref_one, ref_two = model.reflections.values

      ref_one_name = (ref_two.inverse_of.has_one? ? ref_one.name : ref_one.klass.table_name.split('.').first).to_sym
      ref_two_name = (ref_one.inverse_of.has_one? ? ref_two.name : ref_two.klass.table_name.split('.').first).to_sym

      ref_one.klass.public_send(ref_one.inverse_of.has_one? ? :has_one : :has_many,
                                ref_two_name, through: ref_one.inverse_of.name, inverse_of: ref_one_name)

      ref_two.klass.public_send(ref_two.inverse_of.has_one? ? :has_one : :has_many,
                                ref_one_name, through: ref_two.inverse_of.name, inverse_of: ref_two_name)
    end
    # rubocop:enable Metrics/AbcSize

    def join_table_model?(model)
      join_columns = model.columns.reject do |column|
        column.name == 'id' || column.name.in?(TIMESTAMP_COLUMNS)
      end

      return unless join_columns.size.in?([2, 3])
      return if model.reflections.size != 2

      belongs_to_reflections = model.reflections.values.select(&:belongs_to?)

      return if belongs_to_reflections.size != 2

      true
    end

    def fetch_table_indexes(model)
      cache_key = connection_url_hash(model) + model.table_name

      TABLE_INDEXES_CACHE[cache_key] ||= model.connection.indexes(model.table_name)
    end

    def load_tables(connection)
      return connection.tables unless defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)

      if connection.instance_of?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
        search_schemas = connection.schema_search_path.split(/\s*,\s*/)

        connection.exec_query(PG_SELECT_TABLES_QUERY).rows.filter_map do |schema, table|
          table if search_schemas.blank? || search_schemas.include?(schema)
        end
      else
        connection.tables
      end
    end

    def fetch_schemas_md5(connection)
      if connection.class.name.include?('PostgreSQL')
        fetch_pg_schema_md5(connection)
      elsif connection.class.name.include?('Mysql2')
        fetch_mysql_schema_md5(connection)
      else
        Digest::MD5.hexdigest('')
      end
    end

    def fetch_pg_schema_md5(connection)
      schemas = connection.schema_search_path.split(/\s*,\s*/).presence || ['public']

      sql = ActiveRecord::Base.sanitize_sql_array([PG_SELECT_SCHEMA_MD5, { schema: schemas }])

      connection.exec_query(sql).rows.first.first
    end

    def fetch_mysql_schema_md5(connection)
      schema = connection.connection_class.connection_db_config.configuration_hash[:database]

      sql = ActiveRecord::Base.sanitize_sql_array([MYSQL_SELECT_SCHEMA_MD5, { schema: schema }])

      Digest::MD5.hexdigest(connection.exec_query(sql).rows.to_json)
    end

    def define_model_reflections(model, base_class)
      model.columns.each do |column|
        next unless column.name.ends_with?('_id')
        next if column.try(:array?)

        belongs_to_name = column.name.delete_suffix('_id')

        next if model.columns_hash["#{belongs_to_name}_type"]

        ref_model = DEFINED_MODELS.dig(base_class.name, belongs_to_name.pluralize)

        next unless ref_model

        define_model_reflection(model, ref_model, column, belongs_to_name.to_sym)
      end
    end

    def define_model_reflection(model, ref_model, column, belongs_to_name)
      is_has_one = fetch_table_indexes(model).any? { |index| index.unique && index.columns == [column.name] }
      inverse_of_name = (is_has_one ? model.name.demodulize.underscore : model.table_name.split('.').last).to_sym

      model.belongs_to(belongs_to_name, optional: column.null, inverse_of: inverse_of_name)

      if is_has_one
        ref_model.has_one(inverse_of_name, dependent: :destroy, inverse_of: belongs_to_name)
      else
        ref_model.has_many(inverse_of_name, dependent: :destroy, inverse_of: belongs_to_name)
      end
    end

    def connection_url_hash(model)
      model.connection_db_config.try(:url).hash.to_s
    end
  end
end
