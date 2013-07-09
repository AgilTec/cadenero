module Cadenero::V1
  # Defines a subdomain with a default admin (owner) as a tenant in the Rails App
  class Account < ActiveRecord::Base
    belongs_to :owner,  :class_name => "Cadenero::User"
    has_many :members, :class_name => "Cadenero::Member"
    has_many :users, :through => :members,  :class_name => "Cadenero::User"
    
    accepts_nested_attributes_for :owner
    attr_accessible :name, :subdomain, :owner_attributes, :owner
    validates :subdomain, :presence => true, :uniqueness => true
    validates :owner, :presence => true

    # Creates an account and assign the provided [Cadenero::User] as owner to the account
    # @param [Hash] params list 
    # @example
    #    Example for the params JSON: {name: "Testy", subdomain: "test", 
    #    owner_attributes: {email: "testy@example.com", password: "changeme", 
    #    password_confirmation: "changeme"} }
    # @return the [Cadenero::V1::Account] created
    # @note because this model uses accepts_nested_attributes_for :owner the JSOB should have owner_attributes
    def self.create_with_owner(params={})
      account = new(params)
      if account.save
        account.users << account.owner
      end
      account
    end

    # Gets the account for the specified subdomain and guards errors 
    # @param [String] params subdomain 
    # @example
    #    get_by_subdomain("www")
    # @return the [Cadenero::V1::Account] for that subdomain  
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

    # Generate authentication token unless already exists.
    def ensure_authentication_token
      reset_authentication_token if authentication_token.blank?
    end

    # Generate authentication token unless already exists and save the record.
    def ensure_authentication_token!
      reset_authentication_token! if authentication_token.blank?
    end

    # Generate new authentication token (a.k.a. "single access token").
    def reset_authentication_token
      self.authentication_token = self.class.authentication_token
    end

    # Generate new authentication token and save the record.
    def reset_authentication_token!
      reset_authentication_token
      save(:validate => false)
    end

    class << self
      # Generate a token checking if one does not already exist in the database.
      def authentication_token
        generate_token(:authentication_token)
      end

      protected
      # Generate a token by looping and ensuring does not already exist.
      # @params [String] column is the name of the column that has the authentication token
      # @return a unique generated authentication_token
      def generate_token(column)
        loop do
          token = SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz')
          break token unless Account.where({ column => token }).first
        end
      end
    end

  end
end
