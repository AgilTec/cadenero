require 'spec_helper'

module Cadenero::V1
  describe Account do
    let(:user) { stub_model(Cadenero::User, email: "user@example.com", password: "password", password_confirmation: "password") }

    it "is valid with valid attributes" do
      expect(Account.new(subdomain: "subdomain", owner: user)).to be_valid
    end

    it "is not valid without a subdomain" do
      account = Account.new(subdomain: nil, owner: user)
      expect(account).not_to be_valid
      expect(account.users).to be_empty
    end

    it "is not valid without a owner" do
      account = Account.new(subdomain: "subdomain", owner: nil)
      expect(account).not_to be_valid
    end

    it "creates a reference for the owner to the users of the account" do
      params = {
        :name => "Test Account",
        :subdomain => "test",
        :owner_attributes => {
          :email => "user@example.com",
          :password => "password",
          :password_confirmation => "password"
        }
      }
      account = Account.create_with_owner(params)
      expect(account.users.first.email).to eq user.email
    end
      
  end
end
