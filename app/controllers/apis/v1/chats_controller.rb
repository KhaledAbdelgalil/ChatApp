module Apis
	module V1
		class ChatsController < ApplicationController
	      def get_chats
	      		app = App.find_by_token(params[:app_token])
			    if app
			      if(app.chats_count != 0)
			     	 render json: {status: 'SUCCESS', message:'Loaded chats', data:app.chats.as_json(only: [:chat_number, :created_at])},status: :ok
			      else 
			      	render json: {status: 'SUCCESS', message:'No chats'},status: :ok
			      end
			    else
			      render json: {status: 'Failed', message: ErrorController.invalid_token(params[:app_token].to_s)}
			    end
	      end


	      def create_chat

	      	CreateChatBackgroundJob.perform_later(params[:app_token])
	      	render json: {status:'SUCCESS to take your job', message:"we have taken your job in queue"}
		    
			      
	      end

	      def get_messages_count
		    application = App.find_by_token(params[:app_token])
		    if application
		      chat = application.chats.find_by_chat_number(params[:chat_number])
		      if chat
		      	render json: {status: 'SUCCESS', data:chat.messages_count}
		      else
		        render json: {status: 'Failed', message:ErrorController.invalid_chat_number(params[:chat_number].to_s)}
		      end
		    else
		      render json: {status: 'Failed', message:ErrorController.invalid_token(params[:app_token].to_s)}
		    end
  		  end

		  private
	      def chat_params
	        params.permit(:chat_number, :app_token)
	      end
		end
	end
end