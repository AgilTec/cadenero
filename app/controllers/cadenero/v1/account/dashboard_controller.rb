require_dependency "cadenero/application_controller"

module Cadenero
  class V1::Account::DashboardController < Cadenero::ApplicationController
    before_filter :authenticate_user!

    def index
      
    end
  end
end
