Rails.application.routes.draw do

  match '/auth/auth0/callback', via: :get, to: 'auth0#callback'
  match '/auth/failure', via: :get, to: 'auth0#failure'
  match '/logout', via: :delete, to: 'auth0#logout'

  match '/dashboard', via: :get, to: 'dashboard#index'

  root 'public_pages#home'
end

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
