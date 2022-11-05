# frozen_string_literal: true

# Database schema for chats
class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.integer :chat_number
      t.integer :messages_count
      t.references :app, null: false, foreign_key: true

      t.timestamps
    end
    add_index :chats, :chat_number
    change_column_default :chats, :messages_count, 0
  end
end
