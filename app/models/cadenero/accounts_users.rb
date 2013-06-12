module Cadenero
  class AccountsUsers < ActiveRecord::Base
    belongs_to :account,  :class_name => "Cadenero::Account"
    belongs_to :user,  :class_name => "Cadenero::User"
    # attr_accessible :title, :body
  end
end
