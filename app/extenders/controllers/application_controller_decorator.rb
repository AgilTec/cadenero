::ApplicationController.class_eval do

 def current_account
    if user_signed_in?
      @current_account ||= begin
        Cadenero::Account.find_by_subdomain(request.subdomain)
      end
    end
  end
  helper_method :current_account

  def current_user
    if user_signed_in?
      @current_user ||= begin
        user_id = env['warden'].user(:scope => :user)
        Cadenero::User.find(user_id)
      end
    end
  end
  helper_method :current_user
  
  def user_signed_in?
    env['warden'].authenticated?(:user)
  end
  helper_method :user_signed_in?

  def authenticate_user!
    unless user_signed_in?
      errors = "Please sign in."
      render json: {errors: errors, links: "/accounts"}, status: 422
    end
  end

  def force_authentication!(user)
    env['warden'].set_user(user.id, :scope => :user)
  end

end