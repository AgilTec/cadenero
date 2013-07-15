module Cadenero
  # Defines that a Cadenero::User is member of an Cadenero::V1::Account
  class Member < ActiveRecord::Base
    belongs_to :account,  :class_name => "Cadenero::V1::Account"
    belongs_to :user,  :class_name => "Cadenero::User"
    after_create :ensure_auth_token!

    # Generate authentication token unless already exists.
    def ensure_auth_token
      reset_auth_token if auth_token.blank?
    end

    # Generate authentication token unless already exists and save the record.
    def ensure_auth_token!
      reset_auth_token! if auth_token.blank?
    end

    # Generate new authentication token (a.k.a. "single access token").
    def reset_auth_token
      self.auth_token = self.class.auth_token
    end

    # Generate new authentication token and save the record.
    def reset_auth_token!
      reset_auth_token
      save(:validate => false)
    end

    class << self
      # Generate a token checking if one does not already exist in the database.
      def auth_token
        generate_token(:auth_token)
      end

      protected
      # Generate a token by looping and ensuring does not already exist.
      # @param [String] column is the name of the column that has the authentication token
      # @return {String]} a unique generated auth_token
      def generate_token(column)
        loop do
          token = SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz')
          break token unless Member.where({ column => token }).first
        end
      end
    end

  end
  
end
