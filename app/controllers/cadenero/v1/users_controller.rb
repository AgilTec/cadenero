require_dependency "cadenero/application_controller"

module Cadenero
  module V1
    class Account::UsersController < Cadenero::ApplicationController
      def create
        account = Cadenero::V1::Account.where(subdomain: request.subdomain).first
        @user = account.users.create(params[:user])
        force_authentication!(@user)
        render json: @user, status: 201
      end
    end
  end
end
