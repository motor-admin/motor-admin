# frozen_string_literal: true

module Motor
  class AdminUser < ::Motor::ApplicationRecord
    devise :database_authenticatable, :recoverable, :rememberable, :validatable, :trackable, :lockable

    has_many :admin_user_roles, dependent: :destroy
    has_many :roles, through: :admin_user_roles

    def self.public
      Motor::AdminUser.new(roles: [Motor::Role.public])
    end

    def remember_me
      true
    end

    def impersonate_token
      timestamp = Time.current.to_i

      Digest::SHA1.hexdigest(ENV['SECRET_KEY_BASE'].to_s + id.to_s + timestamp.to_s) +
        Base64.encode64([id, timestamp].to_json).unpack1('h*')
    end

    def role_names
      load_roles_from_cache if @role_names.blank?

      @role_names
    end

    def rules
      load_roles_from_cache if @rules.blank?

      @rules
    end

    private

    def load_roles_from_cache
      roles = Motor::AdminUsers.load_roles_from_cache(self)

      @role_names = roles.pluck('name')
      @rules = roles.flat_map { |r| r['rules'] }
    end
  end
end
