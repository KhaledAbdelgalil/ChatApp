# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_220_814_111_118) do
  create_table 'apps', charset: 'utf8mb4', force: :cascade do |t|
    t.string 'name'
    t.string 'token'
    t.integer 'chats_count', default: 0
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['token'], name: 'index_apps_on_token'
  end

  create_table 'chats', charset: 'utf8mb4', force: :cascade do |t|
    t.integer 'chat_number'
    t.integer 'messages_count', default: 0
    t.bigint 'app_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['app_id'], name: 'index_chats_on_app_id'
    t.index ['chat_number'], name: 'index_chats_on_chat_number'
  end

  create_table 'messages', charset: 'utf8mb4', force: :cascade do |t|
    t.integer 'message_number'
    t.text 'content'
    t.bigint 'chat_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['chat_id'], name: 'index_messages_on_chat_id'
    t.index ['message_number'], name: 'index_messages_on_message_number'
  end

  add_foreign_key 'chats', 'apps'
  add_foreign_key 'messages', 'chats'
end
