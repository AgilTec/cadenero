require 'warden'
module Cadenero
  class Engine < ::Rails::Engine
    isolate_namespace Cadenero
    config.middleware.use Warden::Manager do |manager|
      manager.default_strategies :password
    end

    config.generators do |g|                                                               
      g.test_framework :rspec
      g.integration_tool :rspec
    end

    config.to_prepare do
      root = Cadenero::Engine.root
      extenders_path = root + "app/extenders/**/*.rb"
      Dir.glob(extenders_path) do |file|
        Rails.configuration.cache_classes ? require(file) : load(file)
      end
    end

    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore

  end
end
