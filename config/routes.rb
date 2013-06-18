require 'cadenero/constraints/subdomain_required'

Cadenero::Engine.routes.draw do
  namespace :v1 do
    get "users/new"

    constraints(Cadenero::Constraints::SubdomainRequired) do
      scope :module => "account" do
        root :to => "dashboard#index"
        get '/sign_in', :to => "sessions#new"
        post '/sign_in', :to => "sessions#create", :as => :sessions
        get '/sign_up', :to => "users#new", :as => :user_sign_up
        post '/sign_up', :to => "users#create", :as => :user_sign_up
      end
    end
    get '/sign_up', :to => "accounts#new", :as => :sign_up
    post '/accounts', :to => "accounts#create", :as => :accounts

    root :to => "dashboard#index"

  end
  # post '/v1/accounts', :to => "v1/accounts#create", :as => :accounts

end
