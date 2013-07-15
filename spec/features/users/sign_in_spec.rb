require 'spec_helper'
require 'cadenero/testing_support/subdomain_helpers'
require 'cadenero/testing_support/authentication_helpers'

feature 'User sign in' do
  extend Cadenero::TestingSupport::SubdomainHelpers
  include Cadenero::TestingSupport::AuthenticationHelpers

  let(:account) { FactoryGirl.create(:account_with_schema) }
  let(:errors_redirect_ro_sign_in) {{errors: %Q{Please sign in. posting the user json credentials as: {"user": {"email": "testy2@example.com", "password": "changeme"}} to /v1/sessions}, links: "/v1/sessions"}.to_json}
  let(:errors_invalid_email_or_password)  {{ errors: {user:["Invalid email or password"]} }.to_json} 
  let(:errors_invalid_subdomain)  {{ errors: {subdomain:["Invalid subdomain"]} }.to_json} 
  let(:sessions_url) { "http://#{account.subdomain}.example.com/v1/sessions" }
  let(:error_url) { "http://error.example.com/v1/sessions" }
  let(:root_url) { "http://#{account.subdomain}.example.com/v1" }

  within_account_subdomain do
    scenario "signs in as an account owner successfully" do
      check_error_for_not_signed_in_yet
      user_email = successful_sign_in_owner account
      get root_url
      expect(last_response.status).to eq 200
      expect(json_last_response_body["message"]).to have_content user_email
    end

    scenario "signs in as a user successfully" do
      check_error_for_not_signed_in_yet
      second_user_email = successful_sign_up_user_in_existing_account account, "_second"
      second_user = Cadenero::User.where(email: second_user_email).first
      successful_sign_in_user(account, account_user_params_json(second_user))
      get root_url
      expect(last_response.status).to eq 200
      expect(json_last_response_body["message"]).to have_content second_user_email
    end

    scenario "signout as an account owner successfully" do
      user_email = successful_sign_in_owner account 
      delete sessions_url, id: account.owner.id
      expect(last_response.status).to eq 200
      expect(json_last_response_body["message"]).to have_content "Successful logout"
      check_error_for_not_signed_in_yet
    end

  end

  context "without sign in" do
    scenario "attempts sign in with an invalid password and fails" do
      check_error_for_not_signed_in_yet
      sign_in_user sessions_url, { email: "user@example.com", password: "" }
      expected_json_errors(errors_invalid_email_or_password)
    end

    scenario "attempts sign in with an invalid email address and fails" do
      check_error_for_not_signed_in_yet
      sign_in_user sessions_url, { email: "foo@example.com", password: "password"}
      expected_json_errors(errors_invalid_email_or_password)
    end

    scenario "cannot sign in if not a member of an existing subdomain" do
      other_account = FactoryGirl.create(:account)
      check_error_for_not_signed_in_yet
      sign_in_user sessions_url, { email: other_account.owner.email, password: "password" }
      expected_json_errors(errors_invalid_email_or_password)
    end

    scenario "cannot sign in if the subdomain does not exist" do 
      sign_in_user error_url, account_user_params_json(account.owner)
      expected_json_errors(errors_invalid_subdomain)
    end
  end 
end