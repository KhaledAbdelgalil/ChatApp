class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.integer :message_number
      t.text :content
      t.references :chat, null: false, foreign_key: true

      t.timestamps
    end
    add_index :messages, :message_number
  end
end
