# frozen_string_literal: true

module Apis
  module V1
    # Errors Controller : handles the errors produced during performing the endpoints
    class ErrorController < ApplicationController
      def self.invalid_token(app_token)
        "Unsuccessful: Invalid token sent #{app_token}"
      end

      def self.invalid_chat_number(chat_number)
        "Unsuccessful: Invalid chat number sent #{chat_number}"
      end

      def self.invalid_message_number(message_number)
        "Unsuccessful: Invalid message number sent #{message_number}"
      end
    end
  end
end
