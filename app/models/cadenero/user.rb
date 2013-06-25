module Cadenero
  class User < ActiveRecord::Base
    attr_accessible :email, :password, :password_confirmation
    has_secure_password
    has_many :members, :class_name => "Cadenero::Member"
    has_many :accounts, :through => :members
  end
end
