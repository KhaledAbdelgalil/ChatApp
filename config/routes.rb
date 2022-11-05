# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # end points of applications
  # post '/applications/create', to: 'apps#get_token'

  namespace 'apis' do
    namespace 'v1' do
      # read applications
      get '/applications/', to: 'apps#show_all'
      # read specific application
      get '/applications/:app_token', to: 'apps#show_one'
      # create application
      post '/applications/create', to: 'apps#create_app'

      # get chats_count of application
      get '/applications/:app_token/chats_count', to: 'apps#chats_count'

      # update name of application
      put '/applications/:app_token/update', to: 'apps#update'

      # chats
      # get_chats
      get '/applications/:app_token/chats/get', to: 'chats#chats'

      # create chat
      post '/applications/:app_token/chats/create', to: 'chats#create_chat'

      # get messages count of chat
      get '/applications/:app_token/chats/:chat_number/messages_count', to: 'chats#messages_count'

      # messages
      # get all messages in a chat
      get '/applications/:app_token/chats/:chat_number/messages/get', to: 'messages#messages'

      # get specific message
      get '/applications/:app_token/chats/:chat_number/messages/:message_number', to: 'messages#message'

      # create message
      post '/applications/:app_token/chats/:chat_number/messages/create', to: 'messages#create_message'

      # update message
      put '/applications/:app_token/chats/:chat_number/messages/:message_number/update', to: 'messages#update_message'

      # search message
      get '/applications/:app_token/chats/:chat_number/search', to: 'messages#search'
    end
  end

  # update application
end
