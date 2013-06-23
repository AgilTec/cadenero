require_dependency "cadenero/application_controller"

module Cadenero::V1
  class Account::SessionsController < Cadenero::ApplicationController
    def create
      if env['warden'].authenticate(:scope => :user)
        render json: current_user, status: 201
      else
        render json: {errors: {user:["Invalid email or password"]}}, status: 422
      end
    end
  end
end
