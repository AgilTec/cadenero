# Mixin for Models that have an auth_token
module Cadenero::AuthToken

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
    self.auth_token = generate_token(:auth_token)
  end

  # Generate new authentication token and save the record.
  def reset_auth_token!
    reset_auth_token
    save(:validate => false)
  end

  protected
  # Generate a token by looping and ensuring does not already exist.
  # @param [String] column is the name of the column that has the authentication token
  # @return {String]} a unique generated auth_token
  def generate_token(column)
    loop do
      token = SecureRandom.base64(15).tr('+/=lIO0', 'pqrsxyz')
      break token unless self.class.where({ column => token }).first
    end
  end
end
