# frozen_string_literal: true

module Apis
  module V1
    # Messages Controller : contains endpoints(actions) needed for the messages model
    class MessagesController < ApplicationController
      def messages
        application = App.find_by_token(params[:app_token])
        if application
          chat = Chat.find_by(app_id: application.id, chat_number: params[:chat_number])
          if chat
            messages = chat.messages.as_json(only: %i[message_number content created_at updated_at])
            render json: { status: 'SUCCESS', message: 'Loaded Chats', data: messages }, status: :ok
          else
            render json: { status: 'Failed',
                           message: ErrorController.invalid_chat_number(params[:chat_number].to_s) }
          end
        else
          render json: { status: 'Failed', message: ErrorController.invalid_token(params[:app_token].to_s) }
        end
      end

      # specific message
      def message
        application = App.find_by_token(params[:app_token])
        if application
          chat = Chat.find_by(app_id: application.id, chat_number: params[:chat_number])
          if chat
            message = Message.find_by(chat_id: chat.id, message_number: params[:message_number])
            if message
              render json: message.as_json(only: %i[message_number content created_at updated_at])
            else
              render json: { status: 'Failed',
                             message: ErrorController.invalid_message_number(params[:message_number].to_s) }
            end
          else
            render json: { status: 'Failed', message: ErrorController.invalid_chat_number(params[:chat_number].to_s) }
          end
        else
          render json: { status: 'Failed', message: ErrorController.invalid_token(params[:app_token].to_s) }
        end
      end

      def create_message
        content_to_use = params[:content]
        token = params[:app_token]
        chat_number = params[:chat_number]

        CreateMessageBackgroundJob.perform_later(content_to_use, token, chat_number)
        render json: { status: 'SUCCESS to take your job', message: 'we have taken your job in queue' }
      end

      def update_message
        content_to_use = message_params[:content]
        if !content_to_use.nil?
          application = App.find_by_token(params[:app_token])
          if application
            chat = application.chats.find_by_chat_number(params[:chat_number])
            if chat
              message = Message.find_by(chat_id: chat.id, message_number: params[:message_number])
              if message
                if message.update({ content: content_to_use })
                  render json: message.as_json(only: %i[message_number content created_at updated_at])
                else
                  render json: message.errors, status: :unprocessable_entity
                end
              else
                render json: ErrorController.invalid_message_number(params[:message_number].to_s)
              end
            else
              render json: ErrorController.invalid_chat_number(params[:chat_number].to_s)
            end
          else
            render json: ErrorController.invalid_token(params[:app_token].to_s)
          end
        else
          render json: 'Unsuccessful: cannot accept nil POST body for message content'
        end
      end

      def search
        if params[:query]
          application = App.find_by_token(params[:app_token])
          if application
            chat = Chat.find_by(app_id: application.id, chat_number: params[:chat_number])
            if chat
              search_results = Message.search(params[:query])
              return_results = { 'results' => [] }
              search_results.each do |result_item|
                next unless chat.id == result_item['_source']['chat_id']

                message_number = result_item['_source']['message_number']
                content = result_item['_source']['content']
                return_results['results'] << { message_number: message_number, content: content }
              end
              render json: return_results
            else
              render json: { status: 'Failed',
                             message: ErrorController.invalid_chat_number(params[:chat_number].to_s) }
            end
          else
            render json: { status: 'Failed', message: ErrorController.invalid_token(params[:app_token].to_s) }
          end
        else
          render json: { status: 'Failed', message: 'Unsuccessful: Invalid query parameter' }
        end
      end

      private

      def message_params
        params.permit(:chat_number, :app_token, :content)
      end
    end
  end
end
