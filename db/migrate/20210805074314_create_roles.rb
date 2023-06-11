# frozen_string_literal: true

class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :motor_roles, if_not_exists: true do |t|
      t.string :name, null: false, index: { unique: true }
      t.text :rules, null: false

      t.timestamps

      t.index :updated_at
    end
  end
end
