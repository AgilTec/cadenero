Cadenero::Engine.routes.draw do
  namespace :v1 do
    resources :users
    resources :accounts
  end
  # post '/v1/accounts', :to => "v1/accounts#create", :as => :accounts

end
