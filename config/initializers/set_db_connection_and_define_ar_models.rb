# frozen_string_literal: true

Rails.configuration.to_prepare do
  Motor::ApplicationController.include(Module.new do
    extend ActiveSupport::Concern

    included do
      prepend_before_action :set_db_connection_and_define_ar_models
    end

    def set_db_connection_and_define_ar_models
      database_configs = Motor::EncryptedConfig.find_by(key: Motor::EncryptedConfig::DATABASE_CREDENTIALS_KEY)

      if database_configs
        database_config = database_configs.value.first

        if database_config['url'] && ::ResourceRecord.connection_db_config.try(:url) != database_config['url']
          ::ResourceRecord.establish_connection(database_config)
        end
      else
        demo_db_path = '/tmp/motor-admin-demo.sqlite3'
        demo_params = { adapter: :sqlite3, database: demo_db_path }

        File.write(demo_db_path, Rails.root.join('motor-admin-demo.sqlite3').read) unless File.exist?(demo_db_path)
        ::ResourceRecord.establish_connection(demo_params)
      end

      Motor::DefineArModels.call
    end
  end)
end
