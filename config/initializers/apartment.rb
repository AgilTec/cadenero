Rails.application.config.middleware.use 'Apartment::Elevators::Subdomain'


Apartment.configure do |config|
  config.excluded_models = ["Cadenero::V1::Account",
                             "Cadenero::Member",
                             "Cadenero::User"]
  # Dynamically get database names to migrate
  # config.database_names = lambda{ Account.pluck(:database_name) }
end