class CreateVoiceGenerations < ActiveRecord::Migration[8.1]
  def change
    create_table :voice_generations do |t|
      t.text :text, null: false
      t.string :status, null: false, default: 'pending'
      t.string :voice_id, null: false
      t.string :audio_url
      t.float :duration_seconds
      t.integer :file_size_bytes
      t.text :error_message
      t.string :notify_email
      t.datetime :email_sent_at
      t.datetime :completed_at

      t.timestamps
    end

    add_index :voice_generations, :status
    add_index :voice_generations, :created_at
  end
end