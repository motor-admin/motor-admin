# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Rails/CreateTableWithTimestamps, Metrics/ClassLength
class InstallMotorAdmin < ActiveRecord::Migration[7.0]
  def self.up
    create_table :motor_queries, if_not_exists: true do |t|
      t.column :name, :string, null: false
      t.column :description, :text
      t.column :sql_body, :text, null: false
      t.column :preferences, :text, null: false
      t.column :author_id, :bigint
      t.column :author_type, :string
      t.column :deleted_at, :datetime

      t.timestamps

      t.index :updated_at
      t.index 'name',
              name: 'motor_queries_name_unique_index',
              unique: true,
              where: 'deleted_at IS NULL'
    end

    create_table :motor_dashboards, if_not_exists: true do |t|
      t.column :title, :string, null: false
      t.column :description, :text
      t.column :preferences, :text, null: false
      t.column :author_id, :bigint
      t.column :author_type, :string
      t.column :deleted_at, :datetime

      t.timestamps

      t.index :updated_at
      t.index 'title',
              name: 'motor_dashboards_title_unique_index',
              unique: true,
              where: 'deleted_at IS NULL'
    end

    create_table :motor_forms, if_not_exists: true do |t|
      t.column :name, :string, null: false
      t.column :description, :text
      t.column :api_path, :text, null: false
      t.column :http_method, :string, null: false
      t.column :preferences, :text, null: false
      t.column :author_id, :bigint
      t.column :author_type, :string
      t.column :deleted_at, :datetime

      t.timestamps

      t.index :updated_at
      t.index 'name',
              name: 'motor_forms_name_unique_index',
              unique: true,
              where: 'deleted_at IS NULL'
    end

    create_table :motor_resources, if_not_exists: true do |t|
      t.column :name, :string, null: false, index: { unique: true }
      t.column :preferences, :text, null: false

      t.timestamps

      t.index :updated_at
    end

    create_table :motor_configs, if_not_exists: true do |t|
      t.column :key, :string, null: false, index: { unique: true }
      t.column :value, :text, null: false

      t.timestamps

      t.index :updated_at
    end

    create_table :motor_alerts, if_not_exists: true do |t|
      t.references :query, null: false, foreign_key: { to_table: :motor_queries }, index: true
      t.column :name, :string, null: false
      t.column :description, :text
      t.column :to_emails, :text, null: false
      t.column :is_enabled, :boolean, null: false, default: true
      t.column :preferences, :text, null: false
      t.column :author_id, :bigint
      t.column :author_type, :string
      t.column :deleted_at, :datetime

      t.timestamps

      t.index :updated_at
      t.index 'name',
              name: 'motor_alerts_name_unique_index',
              unique: true,
              where: 'deleted_at IS NULL'
    end

    create_table :motor_alert_locks, if_not_exists: true do |t|
      t.references :alert, null: false, foreign_key: { to_table: :motor_alerts }
      t.column :lock_timestamp, :string, null: false

      t.timestamps

      t.index %i[alert_id lock_timestamp], unique: true
    end

    create_table :motor_tags, if_not_exists: true do |t|
      t.column :name, :string, null: false

      t.timestamps

      t.index 'name',
              name: 'motor_tags_name_unique_index',
              unique: true
    end

    create_table :motor_taggable_tags, if_not_exists: true do |t|
      t.references :tag, null: false, foreign_key: { to_table: :motor_tags }, index: true
      t.column :taggable_id, :bigint, null: false
      t.column :taggable_type, :string, null: false

      t.index %i[taggable_id taggable_type tag_id],
              name: 'motor_polymorphic_association_tag_index',
              unique: true
    end

    create_table :motor_audits, if_not_exists: true do |t|
      t.column :auditable_id, :string
      t.column :auditable_type, :string
      t.column :associated_id, :string
      t.column :associated_type, :string
      t.column :user_id, :bigint
      t.column :user_type, :string
      t.column :username, :string
      t.column :action, :string
      t.column :audited_changes, :text
      t.column :version, :bigint, default: 0
      t.column :comment, :text
      t.column :remote_address, :string
      t.column :request_uuid, :string
      t.column :created_at, :datetime
    end

    add_index :motor_audits, %i[auditable_type auditable_id version], name: 'motor_auditable_index', if_not_exists: true
    add_index :motor_audits, %i[associated_type associated_id], name: 'motor_auditable_associated_index',
                                                                if_not_exists: true
    add_index :motor_audits, %i[user_id user_type], name: 'motor_auditable_user_index', if_not_exists: true
    add_index :motor_audits, :request_uuid, if_not_exists: true
    add_index :motor_audits, :created_at, if_not_exists: true

    model = Class.new(ActiveRecord::Base)
    model.table_name = 'motor_configs'

    model.create!(key: 'header.links', value: [{
      name: '😎 Motor Admin Pro',
      path: 'https://www.getmotoradmin.com/pro'
    },
                                               {
                                                 name: '⭐ Star on GitHub',
                                                 path: 'https://github.com/motor-admin/motor-admin'
                                               }].to_json)

    model.table_name = 'motor_queries'

    model.create!(
      name: 'Hello Query',
      sql_body: "SELECT 'Hello there'",
      preferences: { visualization: 'value' }.to_json
    )

    model.table_name = 'motor_dashboards'

    model.create!(
      title: 'Hello Dashboard',
      preferences: {
        layout: [
          {
            title: 'Hello',
            query_id: 1,
            size: '2x1'
          }
        ]
      }.to_json
    )

    model.table_name = 'motor_forms'

    model.create!(
      name: 'Hello Form',
      api_path: 'https://jsonplaceholder.typicode.com/todos',
      http_method: 'POST',
      preferences: {
        'fields' => [
          {
            'display_name' => 'Message',
            'name' => 'message',
            'field_type' => 'richtext',
            'validators' => [{ 'required' => true }],
            'is_array' => false
          }
        ]
      }.to_json
    )
  end

  def self.down
    drop_table :motor_audits
    drop_table :motor_alert_locks
    drop_table :motor_alerts
    drop_table :motor_forms
    drop_table :motor_taggable_tags
    drop_table :motor_tags
    drop_table :motor_resources
    drop_table :motor_configs
    drop_table :motor_queries
    drop_table :motor_dashboards
  end
end
# rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Rails/CreateTableWithTimestamps, Metrics/ClassLength
