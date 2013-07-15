require 'spec_helper'

module Cadenero
  describe Member do
    let!(:user) { stub_model(Cadenero::User, id: 101, email: "testy@example.com", password: "12345678")}
    let!(:account) { stub_model(Cadenero::V1::Account, id: 1001, authentication_token: "dsdaefer412add", 
      owner: user) }

    it "should have the auth_token" do
      member = Member.new
      member.account = account
      member.user = user
      member.save!
      expect(member.auth_token).not_to eq(nil)
    end
  end
end
