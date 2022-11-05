require 'elasticsearch/model'
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
            query: "*"+query.to_s+"*",
            fields: ['content']
          }
        }
      }
    )
  end
end

