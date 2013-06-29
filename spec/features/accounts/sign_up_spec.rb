require 'spec_helper'

def create_account
  @visitor ||= { name: "Testy", subdomain: "test", owner_attributes:
    {email: "testy@example.com", password: "changeme", password_confirmation: "changeme"} }
end

def find_account_by_name
  @account = Cadenero::V1::Account.where(name: @visitor[:name]).first
end

def sign_up
  create_account
  post "/v1/accounts", format: :json, account: @visitor
  find_account_by_name
end

feature 'Accounts' do
  scenario "creating an account" do
    sign_up
    expect(last_response.status).to eq 201
    expect(JSON.parse(last_response.body)).to have_content "authentication_token"
    expect(JSON.parse(last_response.body)["account"]["authentication_token"]).not_to eq nil
  end

  scenario "cannot create an account with an already used subdomain" do
    create_account
    Cadenero::V1::Account.create!(@visitor)
    sign_up
    expect(last_response.status).to eq 422
    errors = { errors: {subdomain:["has already been taken"]} }
    expect(last_response.body).to eql(errors.to_json)
  end
end