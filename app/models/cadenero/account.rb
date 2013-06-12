module Cadenero
  class Account < ActiveRecord::Base
    belongs_to :owner,  :class_name => "Cadenero::User"
    has_many :accounts_users, :class_name => "Cadenero::AccountsUsers"
    has_many :users, :through => :accounts_users
    
    accepts_nested_attributes_for :owner
    attr_accessible :name, :subdomain, :owner_attributes
    validates :subdomain, :presence => true, :uniqueness => true

    def self.create_with_owner(params={})
      account = new(params)
      if account.save
        account.users << account.owner
      end
      account
    end

    def create_schema
      Apartment::Database.create(subdomain)
    end

    # Generate authentication token unless already exists and save the record.
    def ensure_authentication_token!
      reset_authentication_token! if authentication_token.blank?
    end

    # Generate new authentication token (a.k.a. "single access token").
    def reset_authentication_token!
      self.authentication_token = self.class.authentication_token
    end

    # Generate a token checking if one does not already exist in the database.
    def authentication_token
      generate_token(:authentication_token)
    end

    # Generate a token by looping and ensuring does not already exist.
    def generate_token(column)
      loop do
        token = SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz')
        break token unless Account.where({ column => token }).first
      end
    end


  end
end
