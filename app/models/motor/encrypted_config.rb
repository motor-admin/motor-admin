# frozen_string_literal: true

module Motor
  class EncryptedConfig < ::Motor::ApplicationRecord
    encrypts :value

    serialize :value, Motor::HashSerializer

    DATABASE_URL_KEY = 'database.url'
    EMAIL_SMTP_KEY = 'email.smtp'
  end
end
