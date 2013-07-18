module Cadenero
  # Defines a user of one or more accounts for the multitenant Rails App
  class User < ActiveRecord::Base
    attr_accessible :email, :password, :password_confirmation
    has_secure_password
    has_many :accounts, class_name: "Cadenero::V1::Account", foreign_key: "owner_id"
    has_many :members, class_name: "Cadenero::Member"
    has_many :memberships, through: :members, source: :account

    # Map the auth_tokens for each account that the User is memeber
    def auth_token
      members.map{|member| member.auth_token}
    end
  end
end
