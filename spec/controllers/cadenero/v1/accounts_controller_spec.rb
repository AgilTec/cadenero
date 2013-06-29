require 'spec_helper'

module Cadenero
  describe V1::AccountsController do
    let!(:account) { stub_model(Cadenero::V1::Account, id: 1001, authentication_token: "dsdaefer412add") }
    
    before do
      Cadenero::V1::Account.should_receive(:create_with_owner).and_return(account)
      controller.stub(:force_authentication!)
    end

    context "creates the account's schema" do
      before do
        account.stub :valid? => true
      end     
      it "should create a schema and ensure a token is returned for the account on successful creation" do
        account.should_receive(:create_schema)
        account.should_receive(:ensure_authentication_token!)
        post :create, format: :json, account: { name: "First Account", subdomain: "first" }, use_route: :cadenero
        expect(response.status).to eq(201)
        expect(assigns(:account)).to eq(account)
        expect(assigns(:account)[:authentication_token]).to eq(account.authentication_token)
      end 
    end

    context "when the message fails to save" do
      before do
        account.stub(:save).and_return(false)
        account.stub :valid? => false
      end
      it "assigns @data to error" do
        post :create, format: :json, account: {name: "First Account" }, use_route: :cadenero
        expect(response.status).to eq(422)
        expect(assigns(:data).to_json).to eq({
          errors: account.errors
        }.to_json)
      end
    end 
  end
end

