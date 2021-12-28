class InstallMotorApiConfigs < ActiveRecord::Migration[7.0]
  class MotorApiConfig < ActiveRecord::Base
    self.table_name = 'motor_api_configs'

    encrypts :credentials

    serialize :credentials, Motor::HashSerializer
    serialize :preferences, Motor::HashSerializer

    attribute :preferences, default: -> { HashWithIndifferentAccess.new }
    attribute :credentials, default: -> { HashWithIndifferentAccess.new }
  end

  class MotorForm < ActiveRecord::Base
    self.table_name = 'motor_forms'

    serialize :preferences, Motor::HashSerializer
  end

  class MotorQuery < ActiveRecord::Base
    self.table_name = 'motor_queries'

    serialize :preferences, Motor::HashSerializer
  end

  def up
    create_table :motor_api_configs do |t|
      t.column :name, :string, null: false
      t.column :url, :string, null: false
      t.column :preferences, :text, null: false
      t.column :credentials, :text, null: false
      t.column :description, :text
      t.column :deleted_at, :datetime

      t.timestamps

      t.index 'name',
        name: 'motor_api_configs_name_unique_index',
        unique: true,
        where: 'deleted_at IS NULL'
    end

    add_column :motor_forms, :api_config_name, :string

    MotorForm.all.each do |form|
      if form.api_path.starts_with?('http')
        url = form.api_path[%r{\Ahttps?://[^/]+}]

        form.preferences[:default_values_api_path]&.delete(url)
        form.update!(api_config_name: MotorApiConfig.find_or_create_by!(name: url, url: url).name,
                     api_path: form.api_path.delete(url))
      else
        form.update!(api_config_name: MotorApiConfig.find_or_create_by!(name: 'origin', url: '/').name)
      end
    end

    MotorQuery.all.each do |query|
      next if query.preferences['api_path'].blank?

      if query.preferences['api_path'].starts_with?('http')
        url = query.preferences['api_path'][%r{\Ahttps?://[^/]+}]

        query.preferences['api_path'].delete(url)

        query.preferences['api_config_name'] = MotorApiConfig.find_or_create_by!(name: url, url: url).name
      else
        query.preferences['api_config_name'] = MotorApiConfig.find_or_create_by!(name: 'origin', url: '/').name
      end

      query.save!
    end

    change_column_null :motor_forms, :api_config_name, false

    MotorApiConfig.find_or_create_by!(name: 'origin', url: '/')
  end

  def down
    remove_column :motor_forms, :api_config_name
    drop_table :motor_api_configs
  end
end
