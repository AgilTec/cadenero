require_dependency "cadenero/application_controller"
# Dashboard Controller that can be overrided for be the root access point of your API app
module Cadenero
  #name space for this API version
  class V1::Account::DashboardController < Cadenero::ApplicationController
    # Protecting the site
    before_filter :authenticate_user!

    # Default action
    def index
      render json: {message: "Welcome #{current_user.email}"}, status: :ok # Welcome message for current_user
    end
  end
end
