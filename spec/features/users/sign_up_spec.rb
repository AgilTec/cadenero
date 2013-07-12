require 'spec_helper'
require 'cadenero/testing_support/authentication_helpers'

feature "User signup" do
  include Cadenero::TestingSupport::AuthenticationHelpers

  let!(:account) { FactoryGirl.create(:account_with_schema) }
  let(:root_url) { "http://#{account.subdomain}.example.com/" }
  scenario "under an account" do
    sign_up_user root_url
    expect(last_response.status).to eq 201
    expect(JSON.parse(last_response.body)["user"]["membership_ids"]).to eq [account.id]
    expect(last_request.url).to eq "#{root_url}v1/users"
  end
end