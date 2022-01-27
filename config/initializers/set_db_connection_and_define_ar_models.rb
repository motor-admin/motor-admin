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
          ::ResourceRecord.establish_connection(database_config.merge(prepared_statements: false))
        end
      else
        db_path = "#{ENV['PWD']}/database.sqlite3"
        db_path = '/tmp/motor-admin-demo.sqlite3' unless File.exist?(db_path)

        File.write(db_path, Rails.root.join('motor-admin-demo.sqlite3').read) unless File.exist?(db_path)

        ::ResourceRecord.establish_connection(adapter: :sqlite3, database: db_path)
      end

      Motor::DefineArModels.call
    end
  end)
end
