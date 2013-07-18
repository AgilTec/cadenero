module Cadenero::V1
  # Defines a subdomain with a default admin (owner) as a tenant in the Rails App
  class Account < ActiveRecord::Base
    include Cadenero::AuthToken
    belongs_to :owner,  :class_name => "Cadenero::User"
    has_many :members, :class_name => "Cadenero::Member"
    has_many :users, :through => :members,  :class_name => "Cadenero::User"

    accepts_nested_attributes_for :owner
    attr_accessible :name, :subdomain, :owner_attributes, :owner
    validates :subdomain, :presence => true, :uniqueness => true
    validates :owner, :presence => true
    after_create :ensure_auth_token!

    # Creates an account and assign the provided [Cadenero::User] as owner to the account
    # @param [Hash] params list
    # @example
    #    Example for the params JSON: {name: "Testy", subdomain: "test",
    #    owner_attributes: {email: "testy@example.com", password: "changeme",
    #    password_confirmation: "changeme"} }
    # @return [Cadenero::V1::Account] created
    # @note because this model uses accepts_nested_attributes_for :owner the JSOB should have owner_attributes
    def self.create_with_owner(params={})
      account = new(params)
      if account.save
        account.users << account.owner
        account.create_schema
        account.ensure_auth_token!
      end
      account
    end

    # Gets the account for the specified subdomain and guards errors
    # @param [String] subdomain
    # @example
    #    get_by_subdomain("www")
    # @return [Cadenero::V1::Account] for that subdomain
    def self.get_by_subdomain(subdomain)
      account = find_by_subdomain(subdomain)
      if account
        account
      else
        raise Apartment::SchemaNotFound, "Subdomain is not valid"
      end
    end

    # Create a database schema using the subdomain
    def create_schema
      Apartment::Database.create(subdomain)
    end

  end
end
