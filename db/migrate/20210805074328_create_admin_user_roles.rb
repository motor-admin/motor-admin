# frozen_string_literal: true

class CreateAdminUserRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :motor_admin_user_roles, if_not_exists: true do |t|
      t.references :admin_user, null: false, foreign_key: { to_table: :motor_admin_users }, index: true
      t.references :role, null: false, foreign_key: { to_table: :motor_roles }

      t.timestamps

      t.index %i[role_id admin_user_id], unique: true
    end
  end
end
