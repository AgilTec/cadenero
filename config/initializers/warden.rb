Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.failure_app = Cadenero::V1::Account::DashboardController.action(:index)
  manager.default_strategies :password
end