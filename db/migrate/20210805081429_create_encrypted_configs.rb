# frozen_string_literal: true

class CreateEncryptedConfigs < ActiveRecord::Migration[7.0]
  def change
    create_table :motor_encrypted_configs, if_not_exists: true do |t|
      t.string :key, null: false, index: { unique: true }
      t.text :value, null: false

      t.timestamps

      t.index :updated_at
    end
  end
end
