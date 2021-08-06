# frozen_string_literal: true

module Api
  class EncryptedConfigsController < ApiBaseController
    load_and_authorize_resource class: 'Motor::EncryptedConfig', id_param: :key, find_by: :key

    def index
      render json: { data: @encrypted_configs }
    end

    def show
      render json: { data: @encrypted_config }
    end

    def create
      @encrypted_config =
        Motor::EncryptedConfig.find_or_initialize_by(key: @encrypted_config.key).tap do |config|
          config.value = @encrypted_config.value
        end

      if @encrypted_config.key == Motor::EncryptedConfig::DATABASE_URL_KEY
        verify_db_connection!(@encrypted_config.value)
      end

      @encrypted_config.save!

      render json: { data: @encrypted_config }
    rescue ActiveRecord::RecordNotUnique
      retry
    end

    private

    def verify_db_connection!(url)
      ::ActiveStorage::Record.establish_connection(url)
      ::ResourceRecord.establish_connection(url)

      ::ResourceRecord.connection.verify!
    end

    def encrypted_config_params
      params.require(:data).permit!
    end
  end
end
