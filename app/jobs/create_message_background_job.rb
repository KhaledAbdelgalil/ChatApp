class CreateMessageBackgroundJob < ApplicationJob
  queue_as :default

  def perform(content_to_use, app_token, chat_number)
    # Do something later

        if content_to_use != nil and content_to_use != ""
          application = App.find_by_token(app_token)
          if application
            chat = application.chats.find_by_chat_number(chat_number)
            if chat
              max_till_now =  chat.messages.maximum('message_number')
              if max_till_now
                new_message_number = max_till_now + 1
              else
                new_message_number = 1
              end
              message = Message.new({chat_id: chat.id,message_number: new_message_number, 
                content: content_to_use})
              if message.save
                chat.update(messages_count: chat.messages_count + 1)
              else
                raise Exception.new("error")
              end
            else
              #render json: Apis::V1::ErrorController.invalid_chat_number(chat_number.to_s)
              raise Exception.new(Apis::V1::ErrorController.invalid_chat_number(chat_number.to_s))
            end
          else
            #render json: Apis::V1::ErrorController.invalid_token(app_token.to_s)
            raise Exception.new(Apis::V1::ErrorController.invalid_token(app_token.to_s))
          end
        else
          #render json: "Unsuccessful: cannot accept nil POST body for message content"
          raise Exception.new('Unsuccessful: cannot accept nil POST body for message content')
        end
  end
end
