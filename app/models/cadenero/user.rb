module Cadenero
  class User < ActiveRecord::Base
    attr_accessible :email, :password, :password_confirmation
    has_secure_password
    has_many :accounts, class_name: "Cadenero::V1::Account", foreign_key: "owner_id"
    has_many :members, class_name: "Cadenero::Member"
    has_many :memberships, through: :members, source: :account

    def auth_token      
      accounts[0].authentication_token if accounts[0]
    end
  
  end
end
