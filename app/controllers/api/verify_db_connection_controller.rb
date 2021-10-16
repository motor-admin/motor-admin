# frozen_string_literal: true

module Api
  class VerifyDbConnectionController < ApiBaseController
    InvalidUrl = Class.new(StandardError)

    def create
      authorize!(:manage, :all)

      verify_db_connection!(params[:url])

      head :ok
    end

    private

    def verify_db_connection!(url)
      if url.starts_with?('postgres')
        PG.connect(url).close
      elsif url.starts_with?('mysql')
        uri = URI(url)

        options = {
          username: uri.user,
          host: uri.host,
          password: uri.password,
          port: uri.port,
          database: uri.path.delete_prefix('/')
        }

        Mysql2::Client.new(options).close
      else
        raise InvalidUrl, 'Database URL is invalid'
      end
    end
  end
end
