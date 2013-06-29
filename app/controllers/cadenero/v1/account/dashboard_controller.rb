require_dependency "cadenero/application_controller"

module Cadenero
  class V1::Account::DashboardController < Cadenero::ApplicationController
    before_filter :authenticate_user!

    def index
      render json: {message: "Welcome #{current_user.email}"}, status: :ok
    end
  end
end
