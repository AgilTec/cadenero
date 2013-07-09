module Cadenero
  # JSON Serializaer for the Cadenero::User Model
  class UserSerializer < ActiveModel::Serializer
    embed :ids
    attributes :id, :email, :auth_token
    has_many :accounts
    has_many :memberships

  end
end
