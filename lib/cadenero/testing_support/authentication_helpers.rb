module Cadenero
  # Helper Methods for testing
  module TestingSupport
    # RSpec Helper for subdomains
    module AuthenticationHelpers
      # creates a dummy user for testing
      # @return a dummy user JSON parameters for sign up
      def create_account_params_json_user_params_json_params_json
        @user ||= { email: "user@example.com", password: "password", password_confirmation: "password" }
      end
      # @param user [Cadenero::User]
      # @return [JSON] a dummy user JSON parameters for sign in
      def account_user_params_json(user)
        @user = { email: user.email, password: "password" }
      end

      # find an account in the Database using the email of the owner
      # @return [Cadenero::V1::Account] the corresponding account that was founded
      def find_account_by_email
        @account = Cadenero::V1::Account.where(name: create_account_params_json_user_params_json_params_json[:email]).first
      end
      
      # find an account in the Database using the name of the owner
      # @return [Cadenero::V1::Account] the corresponding account that was founded
      def find_account_by_name
        @account = Cadenero::V1::Account.where(name: @visitor[:name]).first
      end

      # sing in a user sending a POST
      # @param url [String] the URL to be POSTed
      # @param user [Cadenero::User] to be POSTed
      # @return [Cadenero::V1::Account] the corresponding account that was founded
      def sign_in_user(url, user)
        post "#{url}", format: :json, user: user
        find_account_by_email
      end

      # Expect that the JSON response from the server corresponds to the provided msg
      # @param msg [JSON] the  errors: as JSON
      def expected_json_errors(msg)
        expect(last_response.body).to eql(msg)
        expect(last_response.status).to eq 422    
      end

      # Expect that the JSON response will be a default error message when the user has not signed in yet
      # the errors_redirect_ro_sign_in is defined if was not previously defined is a Spec
      def check_error_for_not_signed_in_yet
        errors_redirect_ro_sign_in ||= {errors: %Q{Please sign in. posting the user json credentials as: {"user": {"email": "testy2@example.com", "password": "changeme"}} to /v1/sessions}, links: "/v1/sessions"}.to_json
        get cadenero.v1_root_url(:subdomain => account.subdomain)
        expected_json_errors(errors_redirect_ro_sign_in)
      end

      # Sign up a dummy user for testing
      # @return [Cadenero::V1::Account] the corresponding account that was founded
      def sign_up_user(url)
        post "#{url}/v1/users", format: :json, user: create_account_params_json_user_params_json_params_json
        find_account_by_email
      end

      # Expect that the last_response JSON to have an auth_token and that should equal to the provided auth_token
      # @param [String] subject
      # @param [Array] auth_token
      def expect_auth_token(subject, auth_token)
        expect(json_last_response_body).to have_content "auth_token"
        expect(json_last_response_body[subject]["auth_token"]).to eq auth_token
      end
      # Expect that a owner sign in successfuly to an account
      # @param  [Cadenero::V1::Account] account
      # @return [String] email  for the last response user
      def successful_sign_in_owner(account)
        sign_in_user sessions_url, account_user_params_json(account.owner)
        expect(last_response.status).to eq 201
        expect(json_last_response_body["user"]["account_ids"]).to eq [account.id]
        expect_auth_token("user", [account.authentication_token])
        return json_last_response_body["user"]["email"]
      end

      # creates a dummy account for testing
      # @return [JSON] a dummy account JSON parameters
      def create_account_params_json
        @visitor ||= { name: "Testy", subdomain: "test", owner_attributes:
          {email: "testy@example.com", password: "changeme", password_confirmation: "changeme"} }
      end

      # Sign up a dummy account for testing
      # @return [Cadenero::V1::Account] the corresponding account that was founded
      def sign_up_account
        post "/v1/accounts", format: :json, account: create_account_params_json
        find_account_by_name
      end

      # Parse the last_response.body as JSON
      # @return [JSON] for the last_response.body
      def json_last_response_body
        JSON.parse(last_response.body)
      end
    end
  end
end