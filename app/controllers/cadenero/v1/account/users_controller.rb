# == Cadenero::Account::UsersController for creating the users associated to an account
#
#  Inherates methods from the [::ApplicationController] extender
# @author Manuel Vidaurre @mvidaurre <manuel.vidaurre@agiltec.com.mx>

require_dependency "cadenero/application_controller"

module Cadenero
  module V1
    # Controller for managing users for specific accounts
    class Account::UsersController < Cadenero::ApplicationController
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
        @user = account.users.create(params[:user])
        force_authentication!(@user)
        render json: @user, status: :created
      end
      # Send as JSON the user that match the params[:user]
      def show
        @user = account.users.where(params[:user]).first
        render json: @user, status: :ok
      end
    end
  end
end
