require 'spec_helper'
feature 'User sign in' do
  extend SubdomainHelpers

  def create_account_user
    @user ||= { email: "user@example.com", password: "password", password_confirmation: "password" }
  end

  def find_account_by_email
    @account = Cadenero::V1::Account.where(name: @user[:email]).first
  end

  def sign_in_user_param(url, user)
    post "#{url}/v1/sign_in", user: @user
    find_account_by_email
  end

  let(:account) { FactoryGirl.create(:account_with_schema) }
  let(:sign_in_url) { "http://#{account.subdomain}.example.com/v1/sign_in" }
  let(:root_url) { "http://#{account.subdomain}.example.com/v1" }

  within_account_subdomain do
    scenario "signs in as an account owner successfully" do
      get root_url
      expect(last_request.url).to eq sign_in_url
      sign_in_user sign_in_url, create_account_user
      expect(last_response.status).to eq 201
      expect(JSON.parse(last_response.body)["user"]["account_ids"]).to eq [account.id]
      expect(last_request.url).to eq "#{root_url}v1/sign_in"
    end
  end

  it "attempts sign in with an invalid password and fails" do
    get Cadenero.root_url(:subdomain => account.subdomain)
    expect(last_request.url).to eq sign_in_url
    sign_in_user sign_in_url, { email: "user@example.com", password: "", password_confirmation: "" }
    expect(last_response.status).to eq 422
    errors = { errors: {user:["Invalid email or password"]} }
    expect(last_response.body).to eql(errors.to_json)
    expect(last_request.url).to eq "#{root_url}v1/sign_in"
  end

  it "attempts sign in with an invalid email address and fails" do
    get Cadenero.root_url(:subdomain => account.subdomain)
    expect(last_request.url).to eq sign_in_url
    sign_in_user sign_in_url, { email: "foo@example.com", password: "password", password_confirmation: "password" }
    expect(last_response.status).to eq 422
    errors = { errors: {user:["Invalid email or password"]} }
    expect(last_response.body).to eql(errors.to_json)
    expect(last_request.url).to eq "#{root_url}v1/sign_in"
  end

  it "cannot sign in if not a part of this subdomain" do
    other_account = FactoryGirl.create(:account)
    get root_url(:subdomain => account.subdomain)
    expect(last_request.url).to eq sign_in_url
    sign_in_user sign_in_url, { email: other_account.owner.email, password: "", password_confirmation: "" }
    expect(last_response.status).to eq 422
    errors = { errors: {user:["Invalid email or password"]} }
    expect(last_response.body).to eql(errors.to_json)
    expect(last_request.url).to eq "#{root_url}v1/sign_in"
  end  
end