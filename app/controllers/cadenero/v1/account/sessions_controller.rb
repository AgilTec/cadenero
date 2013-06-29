require_dependency "cadenero/application_controller"

module Cadenero::V1
  class Account::SessionsController < Cadenero::ApplicationController
    def create
      Rails.logger.info "params: #{params}"
      if env['warden'].authenticate(:password, :scope => :user)
        render json: current_user, status: :created
      else
        render json: {errors: {user:["Invalid email or password"]}}, status: :unprocessable_entity
      end
    end
    def delete
      user = Cadenero::User.find_by_id(params[:id])
      Rails.logger.info "id: #{params[:id]}"
      Rails.logger.info "user: #{user.to_json}"
      Rails.logger.info "current_user.id: #{current_user}"
      Rails.logger.info "user_signed_in?: #{user_signed_in?}"
      if user_signed_in? 
        env['warden'].logout(:user)
        render json: {message: "Successful logout"}, status: :ok
      else
        render json: {message: "Unsuccessful logout user with id"}, status: :forbidden
      end
    end
  end
end
