require_dependency "cadenero/application_controller"

module Cadenero
  module V1
    class UsersController < Cadenero::ApplicationController
      def create
        puts "Accouts: #{Cadenero::Account.all.to_json}"
        puts Cadenero::Account.where(subdomain: request.subdomain).explain
        account = Cadenero::Account.where(subdomain: request.subdomain).first
        @user = account.users.create(params[:user])
        force_authentication!(@user)
        render json: @user, status: 201
      end
    end
  end
end
