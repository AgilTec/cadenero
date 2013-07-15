# == ApplicationController Extensions for Authentication
#
# Provide methods for manage authentication of users in a multitenant account environment.
#

::ApplicationController.class_eval do

# Returns the current account for the authenticated user.
#
# @return [Cadenero::V1::Account] the current account.
 def current_account
    if user_signed_in?
      @current_account ||= begin
        Cadenero::V1::Account.find_by_subdomain(request.subdomain)
      end
    end
  end

# Returns the current authenticated user.
#
# @return [Cadenero::User] the current account.
  def current_user
    if user_signed_in?
      @current_user ||= begin
        user_id = env['warden'].user(:scope => :user)
        Cadenero::User.find_by_id(user_id)
      end
    end
  end

# Check to see if there is an authenticated user
  def user_signed_in?
    env['warden'].authenticated?(:user) unless env['warden'].nil?
  end

# it the user is not authenticated returns a 422 and an informative error with the link for sign
  def authenticate_user!
    unless user_signed_in?
      @errors = %Q{Please sign in. posting the user json credentials as: {"user": {"email": "testy2@example.com", "password": "changeme"}} to /v1/sessions}
      render json: {errors: @errors, links: "/v1/sessions"}, status: 422
    end
  end

# Authenticate the provided user.
#
# @param user [Cadenero::User] the user to be authenthicated
  def force_authentication!(user)
    env['warden'].set_user(user.id, :scope => :user)
  end

end