# == Cadenero::Account::UsersController for creating the users associated to an account
#
#  Inherates methods from the [::ApplicationController] extender
# @author Manuel Vidaurre @mvidaurre <manuel.vidaurre@agiltec.com.mx>

require_dependency "cadenero/application_controller"

module Cadenero
  module V1
    # Controller for managing users for specific accounts
    class Account::UsersController < Cadenero::ApplicationController
      before_filter :authenticate_user!, except: :create
      # Create a [Cadenero::User] based on the params sended by the client as a JSON with the user inrormation
      #
      # @example Posting the user data to be created in an account via the subdomain
      #   post "http://#{account.subdomain}.example.com/v1/users",
      #   user: { email: "user@example.com", password: "password", password_confirmation: "password" }
      #
      # @return render JSON of [Cadenero::User] created and the status 201 Created: The request has been
      #   fulfilled and resulted in a new resource being created.
      def create
        account = Cadenero::V1::Account.where(subdomain: request.subdomain).first
        @user = account.users.create(user_params)
        force_authentication!(@user)
        render json: @user, serializer: UserSerializer, status: :created
      end

      # Send as JSON the user that match the params[:user]
      def show
        @user = current_account.users.where(id: params[:id]).first
        render json: @user, status: :ok
      end

      # Send as JSON the users for the current_account
      def index
        @users = current_account.users
        render json: @users, status: :ok
      end

      private
      
      # Permited parameters using strong parameters format
      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end

    end
  end
end
