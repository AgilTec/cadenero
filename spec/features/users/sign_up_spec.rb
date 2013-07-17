require 'spec_helper'

feature "User signup" do

  let!(:account) { FactoryGirl.create(:account_with_schema) }
  let(:root_url) { "http://#{account.subdomain}.example.com/" }
  scenario "under an account" do
    user_email = successful_sign_up_user_in_existing_account_with_session account
    expect(user_email).to eq("user@example.com")
  end

  scenario "under two accounts" do
    account_user_email = successful_sign_up_user_in_existing_account_with_session account
    owner = Cadenero::User.where(email: account_user_email).first
    second_account = FactoryGirl.create(:account_with_schema, owner: owner)
    second_account_user_email = successful_sign_up_user_in_existing_account_with_session second_account
    get "#{root_url}v1/users/#{owner.id}"
    expect_subject_ids_to_have("user", "membership_ids", [account.id, second_account.id], 200)
    get "#{root_url}v1/users"
    expect(json_last_response_body["users"].length).to eq 2
  end

end