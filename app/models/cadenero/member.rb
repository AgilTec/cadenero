module Cadenero
  class Member < ActiveRecord::Base
    belongs_to :account,  :class_name => "Cadenero::V1::Account"
    belongs_to :user,  :class_name => "Cadenero::User"
    # attr_accessible :title, :body
  end
end
