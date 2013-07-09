$:.push File.expand_path("../lib", __FILE__)

# Maintain your gems version:
require "cadenero/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cadenero"
  s.version     = Cadenero::VERSION
  s.authors     = ["Manuel Vidaurre"]
  s.email       = ["manuel.vidaurre@agiltec.com.mx"]
  s.homepage    = "http://www.agiltec.com.mx/ruby/gems/cadenero"
  s.summary     = "Rails.API Engine for manage multitenant authentication"
  s.description = "A Rails.API Engine that use Warden for authenticate users using a RESTful API in a multitenant way"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails-api", "~> 0.1.0"
  s.add_dependency "bcrypt-ruby", "~> 3.0.0"
  s.add_dependency "warden", "~> 1.2.1"
  s.add_dependency "apartment", "~> 0.21.1"
  s.add_dependency "strong_parameters", "~> 0.2.1"
  s.add_dependency "active_model_serializers", "~> 0.8.1"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "pg"
  s.add_development_dependency "rspec-rails", "~> 2.14"
  s.add_development_dependency 'coveralls'
  s.add_development_dependency "capybara", "~> 2.1.0"
  s.add_development_dependency "launchy", "~> 2.3.0"
  s.add_development_dependency "factory_girl", "~> 4.2.0"
  s.add_development_dependency "database_cleaner", "~> 1.0.1"
end
