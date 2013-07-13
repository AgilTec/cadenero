require 'spec_helper'

module Cadenero
  describe V1::Account::UsersController do
    let!(:user) { stub_model(Cadenero::User, id: 101, email: "testy@example.com", password: "12345678")}
    let!(:account) { stub_model(Cadenero::V1::Account, id: 1001, authentication_token: "dsdaefer412add", 
      owner: user) }
    let(:errors_redirect_ro_sign_in) {%Q{Please sign in. posting the user json credentials as: {"user": {"email": "testy2@example.com", "password": "changeme"}} to /v1/sessions}}
  

    context "User signed out" do  
      before do
        controller.stub :user_signed_in? => false
      end
      it "should show an error message if a user is requested" do
        get :show, format: :json, id:101, use_route: :cadenero
        expect(response.status).to eq(422)
        expect(assigns(:errors)).to eq(errors_redirect_ro_sign_in)
      end 
    end

    context "User signed in" do  
      before do
        controller.stub :user_signed_in? => true
        controller.stub :current_account => account
        account.stub :users => user
        user.stub :wbere => user
      end

      it "should show the user JSON" do
        get :show, format: :json, id:101, use_route: :cadenero
        expect(response.status).to eq(200)
        expect(assigns(:user)).to eq(errors_redirect_ro_sign_in)
      end 
    end

  end
end

