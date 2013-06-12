require 'spec_helper'

module Cadenero
  describe V1::AccountsController do
    context "creates the account's schema" do

      let!(:account) { stub_model(Cadenero::Account) }
      
      before do
        Cadenero::Account.should_receive(:create_with_owner).and_return(account)
        account.stub :valid? => true
        controller.stub(:force_authentication!)
      end
      
      it "should create a schema and ensure a token is returned for the account on successful creation" do
        account.should_receive(:create_schema)
        account.should_receive(:ensure_authentication_token!)
        post :create, account: { name: "First Account", subdomain: "first" }, use_route: :cadenero
        expect(account.authentication_token).not_to eq nil
      end

    end  
  end
end

