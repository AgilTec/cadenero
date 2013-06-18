require 'spec_helper'

def create_account_user
  @user ||= { email: "user@example.com", password: "password", password_confirmation: "password" }
end

def find_account_by_email
  @account = Cadenero::V1::Account.where(name: @user[:email]).first
end

def sign_up_user(url)
  create_account_user
  post "#{url}/v1/sign_up", user: @user
  find_account_by_email
end

feature "User signup" do
  let!(:account) { FactoryGirl.create(:account_with_schema) }
  let(:root_url) { "http://#{account.subdomain}.example.com/" }
  scenario "under an account" do
    sign_up_user root_url
    expect(last_response.status).to eq 201
    expect(JSON.parse(last_response.body)["user"]["account_ids"]).to eq [account.id]
    expect(last_request.url).to eq "#{root_url}v1/sign_up"
  end
end