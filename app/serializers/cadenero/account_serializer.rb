module Cadenero
  class AccountSerializer < ActiveModel::Serializer
    embed :ids
    attributes :id, :name, :subdomain, :authentication_token
    has_one :owner
    has_many :users
  end
end
