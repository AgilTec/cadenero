module Cadenero
  # Constraints for the routes
  module Constraints
    # For the routes require that a subdomain is defined
    class SubdomainRequired
      def self.matches?(request)
        request.subdomain.present? && request.subdomain != "www"
      end
    end
  end
end