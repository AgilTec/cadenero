require 'cadenero/constraints/subdomain_required'

Cadenero::Engine.routes.draw do
  namespace :v1 do
    constraints(Cadenero::Constraints::SubdomainRequired) do
      scope :module => "account" do
        root :to => "dashboard#index", default: :json
        post '/sessions', :to => "sessions#create", default: :json
        delete '/sessions', :to => "sessions#delete", default: :json
        post '/users', :to => "users#create", default: :json
        get '/users/:id', :to => "users#show", default: :json
      end
    end
    post '/accounts', :to => "accounts#create", :as => :accounts, default: :json

  end
  root :to => "v1/account/dashboard#index", default: :json
  # post '/v1/accounts', :to => "v1/accounts#create", :as => :accounts

end
