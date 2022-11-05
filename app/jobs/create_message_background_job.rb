# frozen_string_literal: true

# CreateMessageBackgroundJob : Create the message in the background
class CreateMessageBackgroundJob < ApplicationJob
  queue_as :default

  def perform(content_to_use, app_token, chat_number)
    # Do something later
    raise StandardError, 'Unsuccessful: cannot accept nil POST body for message content' unless !content_to_use.nil? && (content_to_use != '')

    application = App.find_by_token(app_token)
    raise StandardError, Apis::V1::ErrorController.invalid_token(app_token.to_s) unless application

    chat = application.chats.find_by_chat_number(chat_number)
    raise StandardError, Apis::V1::ErrorController.invalid_chat_number(chat_number.to_s) unless chat

    max_till_now = chat.messages.maximum('message_number')
    new_message_number = if max_till_now
                           max_till_now + 1
                         else
                           1
                         end
    message = Message.new({ chat_id: chat.id, message_number: new_message_number,
                            content: content_to_use })
    raise StandardError, 'error' unless message.save

    chat.update(messages_count: chat.messages_count + 1)
  end
end
