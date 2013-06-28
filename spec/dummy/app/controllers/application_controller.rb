class ApplicationController < ActionController::API

  def cadenero_user
    current_user
  end
  helper_method :cadenero_user

end
