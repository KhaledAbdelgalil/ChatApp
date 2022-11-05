module Apis
  module V1
  class AppsController < ApplicationController
    def show_all
      apps = App.all.as_json(only: [:name, :token, :created_at]);
      if(apps.count != 0)
        render json: {status: 'SUCCESS', message:'Loaded apps', data:apps},status: :ok
      else
           render json: {status: 'SUCCESS', message:'No Apps in database'},status: :ok 
      end
    end

    def show_one
      app = App.find_by_token(params[:app_token])
      if app
        render json: {status: 'SUCCESS', message:'Loaded app', data:app.as_json(only: [:token, :name, :created_at])},status: :ok
      else 
        render json: {status: 'FAILED', message:ErrorController.invalid_token(params[:app_token].to_s)}
      end

    end

    def create_app 
          new_token = SecureRandom.uuid
          app_params_with_token = app_params.merge(token: new_token)
          app = App.new(app_params_with_token)
          
          if app.save
            render json: {status: 'SUCCESS', message: "App is created", data:app.as_json(only: [:token, :name, :created_at])},status: :ok
          else
            render json: {status: 'ERROR', message:'App not created', data:app.errors},status: :unprocessable_entity
          end
    end

    

    def get_chats_count
      app = App.find_by_token(params[:app_token])
      if app
        render json: {status: 'SUCCESS', data:app.chats_count}
      else
        render json: {status: 'Failed', message:ErrorController.invalid_token(params[:app_token].to_s)}
      end
    end

     def update
         app = App.find_by_token(params[:app_token])
         if app
           if app.update(app_params)
                render json: {status: 'SUCCESS', message:'Updated Application', data:app},status: :ok
           else
                render json: {status: 'ERROR', message:'Application not updated', data:app.errors},status: :unprocessable_entity
           end
         else
          render json: {status: 'Failed', message:ErrorController.invalid_token(params[:app_token].to_s)}
         end

    end

    private
     
      def app_params
          params.permit(:name)
      end
  end

end
end