# frozen_string_literal: true

Rails.configuration.to_prepare do
  Motor::ApplicationController.include(Module.new do
    extend ActiveSupport::Concern

    included do
      prepend_before_action :set_db_connection_and_define_ar_models
    end

    def set_db_connection_and_define_ar_models
      database_configs = Motor::EncryptedConfig.find_by(key: Motor::EncryptedConfig::DATABASE_URL_KEY)

      if database_configs && ::ResourceRecord.connection_db_config.try(:url) != database_configs.value
        ::ActiveStorage::Record.establish_connection(database_configs.value)
        ::ResourceRecord.establish_connection(database_configs.value)
      end

      Motor::DefineArModels.call
    end
  end)
end
