require_dependency "cadenero/application_controller"

module Cadenero
  module V1
    class AccountsController < Cadenero::ApplicationController
      def new
        errors = %Q{Please sign up. posting the account json data as {account: { name: "Testy", subdomain: "test", owner_attributes: {email: "testy@example.com", password: "changeme", password_confirmation: "changeme"} }} to /v1/accounts/sign_up}
        render json: {errors: errors, links: "/v1/accounts/sign_up"}, status: 422
      end
      def create
        @account = Cadenero::V1::Account.create_with_owner(params[:account])
        if @account.valid?
          force_authentication!(@account.owner)
          @account.create_schema
          @account.ensure_authentication_token!
          data = {
            account_id: @account.id,
            auth_token: @account.authentication_token
          }
          render json: data, status: 201
        else
          render json: {errors: @account.errors}, status: 422
        end
      end
    end
  end
end
