require_dependency "cadenero/application_controller"

module Cadenero
  module V1
    class AccountsController < Cadenero::ApplicationController
      def create
        @account = Cadenero::Account.create_with_owner(params[:account])
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
          errors = "Sorry, your account could not be created."
          render json: {errors: @account.errors}, status: 422
        end
      end
    end
  end
end
