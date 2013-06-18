module Cadenero
  class UserSerializer < ActiveModel::Serializer
    embed :ids
    attributes :id, :email
    has_many :accounts_users, :class_name => "Cadenero::AccountsUsers"
    has_many :accounts, :through => :accounts_users
  end
end
