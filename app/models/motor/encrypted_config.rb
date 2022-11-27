# frozen_string_literal: true

module Motor
  class EncryptedConfig < ::Motor::ApplicationRecord
    encrypts :value

    serialize :value, Motor::HashSerializer

    DATABASE_CREDENTIALS_KEY = 'database.credentials'
    SLACK_CREDENTIALS_KEY = 'slack.credentials'
    EMAIL_SMTP_KEY = 'email.smtp'
    FILES_STORAGE_KEY = 'files.storage'
  end
end
