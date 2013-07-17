module Cadenero::AuthToken
    # Obtain the authentication_token from the members to be use for the User
  def auth_token
    members.map{|member| member.auth_token}
  end
end
