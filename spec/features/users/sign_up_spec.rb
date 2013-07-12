require 'spec_helper'
require 'cadenero/testing_support/authentication_helpers'

feature "User signup" do
  include Cadenero::TestingSupport::AuthenticationHelpers

  let!(:account) { FactoryGirl.create(:account_with_schema) }
  let(:root_url) { "http://#{account.subdomain}.example.com/" }
  scenario "under an account" do
    sign_up_user root_url
    expect(last_response.status).to eq 201
    expect(json_last_response_body["user"]["membership_ids"]).to eq [account.id]
    expect(last_request.url).to eq "#{root_url}v1/users"
    get "#{root_url}v1/users/#{json_last_response_body['user']['id']}"
    expect(json_last_response_body["user"]["membership_ids"]).to eq [account.id]
  end

  scenario "under two accounts" do
    sign_up_user root_url
    user_id = json_last_response_body['user']['id']
    get "#{root_url}v1/users/#{user_id}"
    expect(json_last_response_body["user"]["membership_ids"]).to eq [account.id]
    second_account = FactoryGirl.create(:account_with_schema, owner: Cadenero::User.where(id: user_id).first)
    sign_up_user "http://#{second_account.subdomain}.example.com/"
    expect(json_last_response_body["user"]["membership_ids"]).to eq [second_account.id]
    get "#{root_url}v1/users/#{user_id}"
    expect(json_last_response_body["user"]["membership_ids"]).to eq [account.id, second_account.id]
  end

end