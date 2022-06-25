# frozen_string_literal: true

require 'motor/configs'

module Motor
  module ConfigsCli
    module_function

    def dump
      Motor::Configs::WriteToFile.write_with_lock

      puts '✅ motor.yml configs file has been updated'
    end

    def load
      Motor::Configs::SyncFromFile.call(with_exception: true)

      puts '✅ configs have been loaded from motor.yml'
    end

    def reload
      ActiveRecord::Base.transaction do
        Motor::Configs.clear
        Motor::Configs::SyncFromFile.call(with_exception: true)
      end

      puts '✅ configs have been re-loaded from motor.yml'
    end

    def sync
      remote_url = ENV['MOTOR_SYNC_REMOTE_URL']
      api_key = ENV['MOTOR_SYNC_API_KEY']

      raise 'Specify target app url using `MOTOR_SYNC_REMOTE_URL` env variable' if remote_url.blank?
      raise 'Specify sync api key using `MOTOR_SYNC_API_KEY` env variable' if api_key.blank?

      Motor::Configs::SyncWithRemote.call(remote_url, api_key)
      Motor::Configs::WriteToFile.write_with_lock

      puts "✅ Motor Admin configurations have been synced with #{remote_url}"
    rescue Motor::Configs::SyncWithRemote::ApiNotFound
      puts '⚠️  Synchronization failed: you need to specify `MOTOR_SYNC_API_KEY` ' \
           'env variable in your remote app in order to enable this feature'
    end
  end
end
