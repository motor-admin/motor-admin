# frozen_string_literal: true

class DeviseCreateAdminUsers < ActiveRecord::Migration[7.0]
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def change
    create_table :motor_admin_users, if_not_exists: true do |t|
      ## Database authenticatable
      t.string :email, null: false, default: ''
      t.string :first_name
      t.string :last_name
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at
      t.datetime :deleted_at

      t.timestamps null: false
    end

    add_index :motor_admin_users, :email,                unique: true, if_not_exists: true
    add_index :motor_admin_users, :reset_password_token, unique: true, if_not_exists: true
    # add_index :motor_admin_users, :confirmation_token,   unique: true
    add_index :motor_admin_users, :unlock_token,         unique: true, if_not_exists: true
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
