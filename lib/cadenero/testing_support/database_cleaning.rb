require 'database_cleaner'

module Cadenero
  module TestingSupport
    # Ensure that Postgresql Schemas will be clean for testing
    module DatabaseCleaning
      # It includes in the RSpec config. The following isntructions should be wrote in `spec_helper.rb`
      #     require 'cadenero/testing_support/database_cleaning'
      #     ...
      #     RSpec.configure do |config|
      #       ...
      #       config.include Cadenero::TestingSupport::DatabaseCleaning
      def self.included(config)
        config.before(:suite) do
          DatabaseCleaner.strategy = :truncation
          DatabaseCleaner.clean_with(:truncation)
          header "Content-Type", "application/json"
        end
        config.before(:each) do
          DatabaseCleaner.start
        end
        config.after(:each) do
          Apartment::Database.reset
          DatabaseCleaner.clean
          connection = ActiveRecord::Base.connection.raw_connection
          schemas = connection.query(%Q{
            SELECT 'drop schema ' || nspname || ' cascade;'
            from pg_namespace 
            where nspname != 'public' 
            AND nspname NOT LIKE 'pg_%'  
            AND nspname != 'information_schema';
          })
          schemas.each do |query|
            connection.query(query.values.first)
          end
        end
      end
    end
  end
end