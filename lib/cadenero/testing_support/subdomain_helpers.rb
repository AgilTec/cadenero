module Cadenero
  # Helper Methods for testing
  module TestingSupport
    # RSpec Helper for subdomains
    module SubdomainHelpers
      # To be use for RSpec features for defining and account with a subdomain visible for Capybara
      def within_account_subdomain
        let(:subdomain_url) { "http://#{account.subdomain}.example.com" }
        before { Capybara.default_host = subdomain_url }
        after { Capybara.default_host = "http://example.com" }
        yield
      end
    end
  end
end