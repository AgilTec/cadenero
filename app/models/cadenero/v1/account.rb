module Cadenero::V1
  class Account < ActiveRecord::Base
    belongs_to :owner,  :class_name => "Cadenero::User"
    has_many :members, :class_name => "Cadenero::Member"
    has_many :users, :through => :members,  :class_name => "Cadenero::User"
    
    accepts_nested_attributes_for :owner
    attr_accessible :name, :subdomain, :owner_attributes, :owner
    validates :subdomain, :presence => true, :uniqueness => true
    after_create :reset_authentication_token!

    # Creates an accout and assign the provided [Cadenero::User] as owner to the account
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

    # Create a database schema using the subdomain
    def create_schema
      Apartment::Database.create(subdomain)
    end

    # Generate authentication token unless already exists and save the record.
    def ensure_authentication_token!
      reset_authentication_token! if authentication_token.blank?
    end

    # Generate new authentication token (a.k.a. "single access token").
    def reset_authentication_token!
      authentication_token = generate_token(:authentication_token)
      puts "authentication_token: #{authentication_token}"
      save!
    end

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
