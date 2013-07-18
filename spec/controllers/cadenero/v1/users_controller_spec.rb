require 'spec_helper'

module Cadenero
  describe V1::Account::UsersController do
    let!(:user) { stub_model(Cadenero::User, id: 101, email: "testy@example.com", password: "12345678")}
    let!(:account) { stub_model(Cadenero::V1::Account, id: 1001, auth_token: "dsdaefer412add", 
      owner: user) }
    let(:errors_redirect_ro_sign_in) {%Q{Please sign in. posting the user json credentials as: {"user": {"email": "testy2@example.com", "password": "changeme"}} or {"user": {"auth_token": d8Ff8uvupXQfChangeMe}} to /v1/sessions}}
  

    context "User signed out" do  
      before do
        controller.stub :user_signed_in? => false
      end
      it "should show an error message if a user is requested" do
        get :show, format: :json, id:101, use_route: :cadenero
        expect(response.status).to eq(422)
        expect(assigns(:errors)).to eq(errors_redirect_ro_sign_in)
      end
      it "should show an error message if the users are requested" do
        get :index, format: :json, use_route: :cadenero
        expect(response.status).to eq(422)
        expect(assigns(:errors)).to eq(errors_redirect_ro_sign_in)
      end  
    end

    context "User signed in" do  
      before do
        controller.stub :user_signed_in? => true
        controller.stub :current_account => account
        controller.stub :current_user => user
        account.stub users: [user]
        account.stub_chain(:users, where: user)
        user.stub first: user
      end

      it "should show the user JSON" do
        get :show, format: :json, id:101, use_route: :cadenero
        expect(response.status).to eq(200)
        expect(assigns(:user)).to eq(user)
        expect(response.body).to eq('{"user":{"id":101,"email":"testy@example.com","auth_token":[],"account_ids":[],"membership_ids":[]}}')
      end
      it "should provide the users JSON list" do
        get :index, format: :json, use_route: :cadenero
        expect(response.status).to eq(200)
        expect(assigns(:users)).to eq([user])
        expect(response.body).to eq('{"users":[{"id":101,"email":"testy@example.com","auth_token":[],"account_ids":[],"membership_ids":[]}]}')
      end 
    end

  end
end

