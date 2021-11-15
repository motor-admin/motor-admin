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
      elsif url.starts_with?('sqlserver')
        TinyTds::Client.new(parse_options(url)).close
      elsif url.starts_with?('mysql')
        Mysql2::Client.new(parse_options(url)).close
      else
        raise InvalidUrl, 'Database URL is invalid'
      end
    end

    def parse_options(url)
      uri = URI(url)

      {
        username: uri.user,
        host: uri.host,
        password: uri.password,
        port: uri.port,
        database: uri.path.delete_prefix('/')
      }
    end
  end
end
