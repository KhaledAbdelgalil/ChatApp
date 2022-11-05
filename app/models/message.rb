# frozen_string_literal: true

require 'elasticsearch/model'

# Message : message model to interact with message table
class Message < ApplicationRecord
  belongs_to :chat, foreign_key: 'chat_id', primary_key: 'id'

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  Message.__elasticsearch__.create_index!
  Message.import

  def self.search(query)
    __elasticsearch__.search(
      {
        size: 20,
        query: {
          query_string: {
            query: "*#{query}*",
            fields: ['content']
          }
        }
      }
    )
  end
end
