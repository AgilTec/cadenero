require_dependency "cadenero/application_controller"

module Cadenero
  module V1
    class AccountsController < Cadenero::ApplicationController
      def new
        errors = %Q{Please sign up. posting the account json data as {account: { name: "Testy", subdomain: "test", owner_attributes: {email: "testy@example.com", password: "changeme", password_confirmation: "changeme"} }} to /v1/accounts/sign_up}
        render json: {errors: errors, links: "/v1/accounts/sign_up"}, status: :unprocessable_entity
      end
      def create
        @account = Cadenero::V1::Account.create_with_owner(params[:account])
        if @account.valid?
          @account.create_schema
          @account.ensure_authentication_token!
          force_authentication!(@account.owner)
          render json: @account, status: :created
        else
          @data = {
            errors: @account.errors
          }
          render json: @data, status: :unprocessable_entity
        end
      end
    end
  end
end
