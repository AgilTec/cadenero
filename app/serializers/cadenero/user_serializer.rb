module Cadenero
  class UserSerializer < ActiveModel::Serializer
    embed :ids
    attributes :id, :email
    has_many :members, :class_name => "Cadenero::Member"
    has_many :accounts, :through => :members

  end
end
