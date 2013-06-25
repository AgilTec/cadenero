module Cadenero
  class AccountSerializer < ActiveModel::Serializer
    embed :ids
    attributes :id, :name, :subdomain
    has_one :owner,  :class_name => "Cadenero::User"
    has_many :members, :class_name => "Cadenero::Member"
    has_many :users, :through => :members
  end
end
