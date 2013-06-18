module Cadenero
  class User < ActiveRecord::Base
    attr_accessible :email, :password, :password_confirmation
    has_secure_password
    has_many :accounts_users, :class_name => "Cadenero::AccountsUser"
    has_many :accounts, :through => :accounts_users
  end
end
