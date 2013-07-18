require File.expand_path('../../../app/extenders/middleware/robustness', __FILE__)

Rails.application.config.middleware.use(Robustness)
Rails.application.config.middleware.use(Apartment::Elevators::Subdomain)

Apartment.configure do |config|
  config.excluded_models = ["Cadenero::V1::Account",
                             "Cadenero::Member",
                             "Cadenero::User"]
end

# Dynamically get database names to migrate
# config.database_names = lambda{ Account.pluck(:database_name) }
Apartment.database_names = lambda{ Cadenero::V1::Account.pluck(:subdomain)}