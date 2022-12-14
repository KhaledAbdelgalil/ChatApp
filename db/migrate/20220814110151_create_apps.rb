# frozen_string_literal: true

# Database schema for apps
class CreateApps < ActiveRecord::Migration[7.0]
  def change
    create_table :apps do |t|
      t.string :name
      t.string :token
      t.integer :chats_count

      t.timestamps
    end
    add_index :apps, :token
    change_column_default :apps, :chats_count, 0
  end
end
