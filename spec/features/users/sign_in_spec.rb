require 'spec_helper'
require 'cadenero/testing_support/subdomain_helpers'

feature 'User sign in' do
  extend Cadenero::TestingSupport::SubdomainHelpers

  def create_account_user
    @user ||= { email: "user@example.com", password: "password", password_confirmation: "password" }
  end

  def account_user(user)
    @user = { email: user.email, password: "password" }
  end

  def find_account_by_email
    create_account_user
    @account = Cadenero::V1::Account.where(name: @user[:email]).first
  end

  def sign_in_user(url, user)
    post "#{url}", format: :json, user: user
    find_account_by_email
  end

  let(:account) { FactoryGirl.create(:account_with_schema) }
  let(:errors_redirect_ro_sign_in) {{errors: %Q{Please sign in. posting the user json credentials as: {"user": {"email": "testy2@example.com", "password": "changeme"}} to /v1/sessions}, links: "/v1/sessions"}.to_json}
  let(:errors_invalid_email_or_password)  {{ errors: {user:["Invalid email or password"]} }.to_json} 
  let(:errors_invalid_subdomain)  {{ errors: {subdomain:["Invalid subdomain"]} }.to_json} 
  let(:sessions_url) { "http://#{account.subdomain}.example.com/v1/sessions" }
  let(:error_url) { "http://error.example.com/v1/sessions" }
  let(:root_url) { "http://#{account.subdomain}.example.com/v1" }

  within_account_subdomain do
    scenario "signs in as an account owner successfully" do
      get cadenero.v1_root_url(:subdomain => account.subdomain)
      expect(last_response.body).to eql(errors_redirect_ro_sign_in)
      expect(last_response.status).to eq 422
      sign_in_user sessions_url, account_user(account.owner)
      expect(last_response.status).to eq 201
      expect(JSON.parse(last_response.body)["user"]["account_ids"]).to eq [account.id]
      user_email = JSON.parse(last_response.body)["user"]["email"]
      expect(JSON.parse(last_response.body)).to have_content "auth_token"
      access_token = JSON.parse(last_response.body)["user"]["auth_token"]
      expect(JSON.parse(last_response.body)["user"]["auth_token"]).to eq account.authentication_token
      get root_url
      expect(last_response.status).to eq 200
      expect(JSON.parse(last_response.body)["message"]).to have_content user_email
    end

    scenario "signout as an account owner successfully" do
      sign_in_user sessions_url, account_user(account.owner)
      expect(last_response.status).to eq 201
      expect(JSON.parse(last_response.body)["user"]["account_ids"]).to eq [account.id]
      user_email = JSON.parse(last_response.body)["user"]["email"]
      delete sessions_url, id: account.owner.id
      expect(last_response.status).to eq 200
      expect(JSON.parse(last_response.body)["message"]).to have_content "Successful logout"
      get cadenero.v1_root_url(:subdomain => account.subdomain)
      expect(last_response.status).to eq 422
      expect(last_response.body).to eql(errors_redirect_ro_sign_in)
    end

  end

  it "attempts sign in with an invalid password and fails" do
    get cadenero.v1_root_url(:subdomain => account.subdomain)
    expect(last_response.body).to eql(errors_redirect_ro_sign_in)
    sign_in_user sessions_url, { email: "user@example.com", password: "", password_confirmation: "" }
    expect(last_response.status).to eq 422
    expect(last_response.body).to eql(errors_invalid_email_or_password)
  end

  it "attempts sign in with an invalid email address and fails" do
    get cadenero.v1_root_url(:subdomain => account.subdomain)
    expect(last_response.body).to eql(errors_redirect_ro_sign_in)
    sign_in_user sessions_url, { email: "foo@example.com", password: "password", password_confirmation: "password" }
    expect(last_response.status).to eq 422
    expect(last_response.body).to eql(errors_invalid_email_or_password)
  end

  it "cannot sign in if not a part of an existing subdomain" do
    other_account = FactoryGirl.create(:account)
    get cadenero.v1_root_url(:subdomain => account.subdomain)
    expect(last_response.body).to eql(errors_redirect_ro_sign_in)
    sign_in_user sessions_url, { email: other_account.owner.email, password: "", password_confirmation: "" }
    expect(last_response.status).to eq 422
    expect(last_response.body).to eql(errors_invalid_email_or_password)
  end

  it "cannot sign in if the subdomain does not exist" do 
    sign_in_user error_url, account_user(account.owner)
    expect(last_response.status).to eq 422
    expect(last_response.body).to eql(errors_invalid_subdomain)
  end   
end