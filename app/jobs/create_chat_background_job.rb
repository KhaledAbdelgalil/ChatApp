class CreateChatBackgroundJob < ApplicationJob
  queue_as :default

  def perform(app_token)
    # Do something later
    application = App.where(token: app_token).first
        if application 
          max_till_now = application.chats.maximum('chat_number')
          if max_till_now
            new_chat_number = max_till_now + 1
          else
            new_chat_number = 1
          end
          #chat_params_with_appId = chat_params.merge(app_id: application.id)
          #chat_params_complete = chat_params_with_appId.merge(chat_number: new_chat_number)
          #chat = Chat.new(chat_params_complete)
          chat = Chat.new({chat_number: new_chat_number,app_id: application.id})

          if chat.save
            puts chat.to_json
            application.update(chats_count: application.chats_count + 1)
            #render json: {status: 'SUCCESS', message: "chat is created", data:chat.as_json(only: [:chat_number, :created_at])},status: :ok
          else
             raise Exception.new(chat.errors)
          end
        else
          raise Exception.new(Apis::V1::ErrorController.invalid_token(app_token.to_s))
        end
            
  end
end
