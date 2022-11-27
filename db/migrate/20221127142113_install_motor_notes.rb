class InstallMotorNotes < ActiveRecord::Migration[7.0]
  def self.up
    create_table :motor_notes do |t|
      t.column :body, :text
      t.column :author_id, :bigint
      t.column :author_type, :string
      t.column :record_id, :string, null: false
      t.column :record_type, :string, null: false
      t.column :deleted_at, :datetime

      t.timestamps

      t.index %i[author_id author_type],
              name: 'motor_notes_author_id_author_type_index'
    end

    create_table :motor_note_tags do |t|
      t.column :name, :string, null: false

      t.timestamps

      t.index 'name',
              name: 'motor_note_tags_name_unique_index',
              unique: true
    end

    create_table :motor_note_tag_tags do |t|
      t.references :tag, null: false, foreign_key: { to_table: :motor_note_tags }, index: true
      t.references :note, null: false, foreign_key: { to_table: :motor_notes }, index: false

      t.index %i[note_id tag_id],
              name: 'motor_note_tags_note_id_tag_id_index',
              unique: true
    end

    create_table :motor_reminders do |t|
      t.column :author_id, :bigint, null: false
      t.column :author_type, :string, null: false
      t.column :recipient_id, :bigint, null: false
      t.column :recipient_type, :string, null: false
      t.column :record_id, :string
      t.column :record_type, :string
      t.column :scheduled_at, :datetime, null: false, index: true

      t.timestamps

      t.index %i[author_id author_type],
              name: 'motor_reminders_author_id_author_type_index'

      t.index %i[recipient_id recipient_type],
              name: 'motor_reminders_recipient_id_recipient_type_index'

      t.index %i[record_id record_type],
              name: 'motor_reminders_record_id_record_type_index'
    end

    create_table :motor_notifications do |t|
      t.column :title, :string, null: false
      t.column :description, :text
      t.column :recipient_id, :bigint, null: false
      t.column :recipient_type, :string, null: false
      t.column :record_id, :string
      t.column :record_type, :string
      t.column :status, :string, null: false

      t.timestamps

      t.index %i[recipient_id recipient_type],
              name: 'motor_notifications_recipient_id_recipient_type_index'

      t.index %i[record_id record_type],
              name: 'motor_notifications_record_id_record_type_index'
    end
  end

  def self.down
    drop_table :motor_note_tag_tags
    drop_table :motor_note_tags
    drop_table :motor_notes
    drop_table :motor_notifications
    drop_table :motor_reminders
  end
end
