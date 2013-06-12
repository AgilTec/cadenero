Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.default_strategies :password
end