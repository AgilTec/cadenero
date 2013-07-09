require_dependency "cadenero/application_controller"
#NameSpace for the V1 API in Cadenero
module Cadenero::V1
  # Controller for managing sessions for the API if you are using the :password Strategy
  class Account::SessionsController < Cadenero::ApplicationController
    # create the session for the user using the password strategy and returning the user JSON
    def create
      if env['warden'].authenticate(:password, :scope => :user)
        #return the user JSON on success
        render json: current_user, status: :created
      else
        #return error mesage in a JSON on error
        render json: {errors: {user:["Invalid email or password"]}}, status: :unprocessable_entity
      end
    end

    # destroy the session for the user using params id
    def delete
      user = Cadenero::User.find_by_id(params[:id])
      if user_signed_in?
        env['warden'].logout(:user)
        render json: {message: "Successful logout"}, status: :ok
      else
        render json: {message: "Unsuccessful logout user with id"}, status: :forbidden
      end
    end
  end
end
