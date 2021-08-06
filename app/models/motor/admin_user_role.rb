# frozen_string_literal: true

module Motor
  class AdminUserRole < ::Motor::ApplicationRecord
    belongs_to :admin_user, touch: true
    belongs_to :role
  end
end
