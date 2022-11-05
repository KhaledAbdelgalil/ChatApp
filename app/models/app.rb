class App < ApplicationRecord
	has_many :chats, :dependent => :destroy, foreign_key: 'app_id', primary_key: 'id'
	validates :name, presence: true
end
