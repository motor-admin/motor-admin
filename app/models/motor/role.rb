# frozen_string_literal: true

module Motor
  class Role < ::Motor::ApplicationRecord
    has_many :admin_user_roles, dependent: :destroy
    has_many :admin_users, through: :admin_user_roles

    serialize :rules, Motor::HashSerializer

    DEFAULT_RULE = {
      actions: [:manage],
      subjects: [:all],
      attributes: [],
      conditions: []
    }.freeze

    DEFAULT_ROLES = [
      SUPERADMIN = 'superadmin',
      ADMIN = 'admin',
      PUBLIC = 'public'
    ].freeze

    def self.superadmin
      create_with(rules: [DEFAULT_RULE]).find_or_create_by(name: SUPERADMIN)
    rescue ActiveRecord::RecordNotUnique
      retry
    end

    def self.admin
      create_with(rules: [DEFAULT_RULE]).find_or_create_by(name: ADMIN)
    rescue ActiveRecord::RecordNotUnique
      retry
    end

    def self.public
      create_with(rules: []).find_or_create_by(name: PUBLIC)
    rescue ActiveRecord::RecordNotUnique
      retry
    end
  end
end
