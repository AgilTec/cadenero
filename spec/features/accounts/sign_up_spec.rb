require 'spec_helper'

feature 'Accounts' do

  let(:errors_already_taken_subdomain)  {{ errors: {subdomain:["has already been taken"]} }.to_json} 

  scenario "creating an account" do
    sign_up_account
    expect(last_response.status).to eq 201
    expect(json_last_response_body).to have_content "auth_token"
    expect(json_last_response_body["account"]["auth_token"]).not_to eq nil
  end

  scenario "cannot create an account with an already used subdomain" do
    Cadenero::V1::Account.create!(create_account_params_json)
    sign_up_account
    expected_json_errors(errors_already_taken_subdomain)
  end
end