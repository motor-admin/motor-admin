# frozen_string_literal: true

module Motor
  module DefineConnectionClasses
    MUTEX = Mutex.new

    module_function

    def call
      database_configs = Motor::EncryptedConfig.find_by(key: Motor::EncryptedConfig::DATABASE_CREDENTIALS_KEY)

      unless database_configs
        @already_defined = true

        return set_demo_db
      end

      base_classes =
        database_configs.value.map do |db_configs|
          db_name, db_url = db_configs.values_at('name', 'url')

          base_class = fetch_or_define_base_class(db_name)

          if base_class.connection_db_config.try(:url) != db_url
            base_class.establish_connection(url: db_url, prepared_statements: false)
          end

          Motor::DefineArModels.call(base_class)
        end

      clear_removed_connection_classes(base_classes)

      @already_defined = true
    end

    def already_defined?
      @already_defined
    end

    def clear_removed_connection_classes(base_classes)
      removed_base_class_names = Motor::DefineArModels::DEFINED_MODELS.keys - base_classes.map(&:name)

      removed_base_class_names.each do |removed_base_class_name|
        Motor::DefineArModels.clear_models(removed_base_class_name.safe_constantize)

        removed_base_class_name.deconstantize.constantize.send(:remove_const, removed_base_class_name.demodulize)
      end
    end

    def set_demo_db
      db_path = "#{ENV['PWD']}/database.sqlite3"
      db_path = '/tmp/motor-admin-demo.sqlite3' unless File.exist?(db_path)

      File.write(db_path, Rails.root.join('motor-admin-demo.sqlite3').read) unless File.exist?(db_path)

      ::ResourceRecord.establish_connection(adapter: :sqlite3, database: db_path)

      Motor::DefineArModels.call(::ResourceRecord)
    end

    def fetch_or_define_base_class(name)
      class_name = name.sub(/\A\d+/, '').parameterize.underscore.classify

      "Motor::DatabaseClasses::#{class_name}".constantize
    rescue NameError
      if name == 'default'
        Motor::DatabaseClasses.const_set(:Default, ::ResourceRecord)
      else
        klass = Class.new(::ActiveRecord::Base)
        klass.abstract_class = true
        klass.inheritance_column = nil

        Motor::DatabaseClasses.const_set(class_name, klass)

        klass
      end
    end
  end
end
