require 'spec_helper'
require 'cadenero/testing_support/authentication_helpers'

feature 'Accounts' do
  include Cadenero::TestingSupport::AuthenticationHelpers

  let(:errors_already_taken_subdomain)  {{ errors: {subdomain:["has already been taken"]} }.to_json} 

  scenario "creating an account" do
    sign_up_account
    expect(last_response.status).to eq 201
    expect(json_last_response_body).to have_content "authentication_token"
    expect(json_last_response_body["account"]["authentication_token"]).not_to eq nil
  end

  scenario "cannot create an account with an already used subdomain" do
    Cadenero::V1::Account.create!(create_account)
    sign_up_account
    expected_json_errors(errors_already_taken_subdomain)
  end
end