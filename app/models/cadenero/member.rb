module Cadenero
  # Defines that a Cadenero::User is member of an Cadenero::V1::Account
  class Member < ActiveRecord::Base
    include Cadenero::AuthToken
    attr_accessible :account_id, :user_id
    belongs_to :account,  :class_name => "Cadenero::V1::Account"
    belongs_to :user,  :class_name => "Cadenero::User"
    after_create :ensure_auth_token!
  end
end
