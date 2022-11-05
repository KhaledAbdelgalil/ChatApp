# frozen_string_literal: true

# App : App model to interact with app table
class App < ApplicationRecord
  has_many :chats, dependent: :destroy, foreign_key: 'app_id', primary_key: 'id'
  validates :name, presence: true
end
