module Cadenero
  class AccountSerializer < ActiveModel::Serializer
    embed :ids
    attributes :id, :name, :subdomain
    has_one :owner,  :class_name => "Cadenero::User"
    has_many :accounts_users, :class_name => "Cadenero::AccountsUsers"
    has_many :users, :through => :accounts_users
  end
end
