# frozen_string_literal: true

module Motor
  class AdminUser < ::Motor::ApplicationRecord
    devise :database_authenticatable, :recoverable, :rememberable, :validatable, :trackable, :lockable

    has_many :admin_user_roles, dependent: :destroy
    has_many :roles, through: :admin_user_roles
  end
end
