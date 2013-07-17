module Cadenero
  # Helper Methods for testing
  module TestingSupport
    # RSpec Helper for subdomains
    module AuthenticationHelpers
      include Warden::Test::Helpers
      # creates a dummy user for testing
      # @return a dummy user JSON parameters for sign up
      def create_user_params_json(suffix = nil)
        @user = { email: "user#{suffix}@example.com", password: "password", password_confirmation: "password" }
      end
      # @param user [Cadenero::User]
      # @return [JSON] a dummy user JSON parameters for sign in
      def account_user_params_json(user)
        @user = { email: user.email, password: "password" }
      end

      # find an account in the Database using the email of the owner
      # @return [Cadenero::V1::Account] the corresponding account that was founded
      def find_account_by_email
        @account = Cadenero::V1::Account.where(name: create_user_params_json[:email]).first
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
        errors_redirect_ro_sign_in ||= {errors: %Q{Please sign in. posting the user json credentials as: {"user": {"email": "testy2@example.com", "password": "changeme"}} or {"user": {"auth_token": d8Ff8uvupXQfChangeMe}} to /v1/sessions}, links: "/v1/sessions"}.to_json
        get cadenero.v1_root_url(:subdomain => account.subdomain)
        expected_json_errors(errors_redirect_ro_sign_in)
      end

      # Sign up a dummy user for testing
      # @return [Cadenero::V1::Account] the corresponding account that was founded
      def sign_up_user(url, suffix=nil)
        post "#{url}/v1/users", format: :json, user: create_user_params_json(suffix)
        find_account_by_email
      end

      # Expect that the last_response JSON to have an auth_token and that should equal to the provided auth_token
      # @param [String] subject
      # @param [Array] auth_token
      def expect_auth_token(subject, auth_token)
        expect(json_last_response_body).to have_content "auth_token"
        expect(json_last_response_body[subject]["auth_token"]).to eq auth_token
      end

      # Expect that the last_response JSON key subject for the ids_key to have the ids_values
      # @param [String] subject The key to look in the JSON
      # @param [String] ids_key THe key for the subject that identify the ids
      # @param [Array] ids_values THe array of expected ids values
      # @param [Integer] http_code Optional expected returned HTTP Code from last_response
      def expect_subject_ids_to_have(subject, ids_key, ids_values, http_code=201)
        expect(last_response.status).to eq http_code
        expect(json_last_response_body[subject][ids_key]).to eq ids_values
      end

      # Expect that a owner sign in successfuly to one of his accounts creating a session
      # @param  [Cadenero::V1::Account] account
      # @return [String] email  for the last response user
      def successful_sign_in_owner_with_session(account)
        sign_in_user sessions_url, account_user_params_json(account.owner)
        expect_subject_ids_to_have("user", "account_ids", [account.id])
        expect_auth_token("user", account.auth_token)
        return json_last_response_body["user"]["email"]
      end

      # Expect that a user sign in successfuly to an account
      # @param  [Cadenero::V1::Account] account
      # @return [String] email  for the last response user
      def successful_sign_in_user_with_session(account, user)
        sign_in_user sessions_url, user
        expect_subject_ids_to_have("user", "membership_ids", [account.id])
        return json_last_response_body["user"]["email"]
      end

      # Expect that a user sign in successfuly to an account
      # @param  [Cadenero::V1::Account] account
      # @return [String] email  for the last response user
      def successful_sign_up_user_in_existing_account_with_session(account, suffix=nil)
        url = "http://#{account.subdomain}.example.com/" 
        sign_up_user url, suffix
        expect(last_request.url).to eq "#{url}v1/users"
        get "#{url}v1/users/#{json_last_response_body['user']['id']}"
        expect_subject_ids_to_have("user", "membership_ids", [account.id], 200)
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