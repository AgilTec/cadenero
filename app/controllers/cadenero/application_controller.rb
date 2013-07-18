# == Cadenero::ApplicationController main application controller
#
#  Inherates methods from the [::ApplicationController] extender
#
module Cadenero
  class ApplicationController < ::ApplicationController
    include ActiveModel::ForbiddenAttributesProtection
  end
end
