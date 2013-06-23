# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment.rb", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'factory_girl'
require 'database_cleaner'
require 'coveralls'

Coveralls.wear!

module ApiHelper
  require 'rack/test'
  include Rack::Test::Methods

  def app
    Rails.application
  end
end
# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  include ApiHelper
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
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
      AND nspname != 'pg_toast' 
      AND nspname != 'pg_catalog' 
      AND nspname != 'information_schema';
    })
    schemas.each do |query|
      connection.query(query.values.first)
    end
  end
end
