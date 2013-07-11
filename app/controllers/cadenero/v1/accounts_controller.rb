require_dependency "cadenero/application_controller"

module Cadenero
  module V1
    # Handles the Accounts for the multitenant. An account creates a subdomain in the server as a route
    # the account has an owner that is the default admin for that account
    class AccountsController < Cadenero::ApplicationController
      # For API consistency provides the example for creating a new account
      def new
        errors = %Q{Please sign up. posting the account json data as {account: { name: "Testy", subdomain: "test", owner_attributes: {email: "testy@example.com", password: "changeme", password_confirmation: "changeme"} }} to /v1/accounts/sign_up}
        render json: {errors: errors, links: "/v1/accounts/sign_up"}, status: :unprocessable_entity
      end
      # Create a [Cadenero::V1::Account] based on the params sended by the client as a JSON with the account inrormation
      #
      # @example Posting the account data to be created in a subdomain
      #   post "http://www.example.com/v1/accounts", 
      #   account: { name: "Testy", subdomain: "test", 
      #     owner_attributes: {email: "testy@example.com", password: "changeme", password_confirmation: "changeme"} }
      #
      # @return render JSON of [Cadenero::V1::Account] created and the status 201 Created: The request has been 
      #   fulfilled and resulted in a new resource being created.
      def create
        @account = Cadenero::V1::Account.create_with_owner(account_params)
        if @account.valid?
          @account.create_schema
          @account.ensure_authentication_token!
          force_authentication!(@account.owner)
          render json: @account, serializer: AccountSerializer, status: :created
        else
          @data = {
            errors: @account.errors
          }
          render json: @data, status: :unprocessable_entity
        end
      end

      private
      
      # Permited parameters using strong parameters format
      def account_params
        params.require(:account).permit(:name, :subdomain, owner_attributes: [:email, :password, :password_confirmation])
      end
    end
  end
end
