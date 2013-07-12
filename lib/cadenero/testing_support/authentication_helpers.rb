module Cadenero
  # Helper Methods for testing
  module TestingSupport
    # RSpec Helper for subdomains
    module AuthenticationHelpers

      def create_account_user
        @user ||= { email: "user@example.com", password: "password", password_confirmation: "password" }
      end

      def account_user(user)
        @user = { email: user.email, password: "password" }
      end

      def find_account_by_email
        @account = Cadenero::V1::Account.where(name: create_account_user[:email]).first
      end

      def sign_in_user(url, user)
        post "#{url}", format: :json, user: user
        find_account_by_email
      end

      def expected_json_errors(msg)
        expect(last_response.body).to eql(msg)
        expect(last_response.status).to eq 422    
      end

      def check_error_for_not_signed_in_yet
        get cadenero.v1_root_url(:subdomain => account.subdomain)
        expected_json_errors(errors_redirect_ro_sign_in)
      end

      def sign_up_user(url)
        post "#{url}/v1/users", format: :json, user: create_account_user
        find_account_by_email
      end

      def successful_sign_in_owner(account)
        sign_in_user sessions_url, account_user(account.owner)
        expect(last_response.status).to eq 201
        expect(JSON.parse(last_response.body)["user"]["account_ids"]).to eq [account.id]
        expect(JSON.parse(last_response.body)).to have_content "auth_token"
        expect(JSON.parse(last_response.body)["user"]["auth_token"]).to eq account.authentication_token
        return JSON.parse(last_response.body)["user"]["email"]
      end

      def create_account
        @visitor ||= { name: "Testy", subdomain: "test", owner_attributes:
          {email: "testy@example.com", password: "changeme", password_confirmation: "changeme"} }
      end

      def find_account_by_name
        @account = Cadenero::V1::Account.where(name: @visitor[:name]).first
      end

      def sign_up_account
        post "/v1/accounts", format: :json, account: create_account
        find_account_by_name
      end
    end
  end
end