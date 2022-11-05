# frozen_string_literal: true

# CreateChatBackgroundJob : create the chat in the background
class CreateChatBackgroundJob < ApplicationJob
  queue_as :default

  def perform(app_token)
    # Do something later
    application = App.where(token: app_token).first
    raise StandardError, Apis::V1::ErrorController.invalid_token(app_token.to_s) unless application

    max_till_now = application.chats.maximum('chat_number')
    new_chat_number = if max_till_now
                        max_till_now + 1
                      else
                        1
                      end
    chat = Chat.new({ chat_number: new_chat_number, app_id: application.id })

    raise StandardError, chat.errors unless chat.save

    puts chat.to_json
    application.update(chats_count: application.chats_count + 1)
  end
end
