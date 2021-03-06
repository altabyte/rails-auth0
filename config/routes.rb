Rails.application.routes.draw do

  # TODO: routing-filter gem does not currently support Rails 5.1
  # filter :locale, exclude: %r{\A/auth/auth0/callback|/auth/failure}

  match '/auth/set-state', via: :post, to: 'auth0#set_state'
  match '/auth/auth0/callback', via: :get, to: 'auth0#callback'
  match '/auth/failure', via: :get, to: 'auth0#failure'
  match '/user/profile', via: :get, to: 'user_profile#edit'
  match '/user/profile', via: %i[patch post], to: 'user_profile#update'
  match '/login', via: :get, to: 'auth0#login', as: :login
  match '/logout', via: :delete, to: 'auth0#logout', as: :logout

  match '/dashboard', via: :get, to: 'dashboard#index', as: :dashboard
  match '/super-admin', via: :get, to: 'dashboard#super_admin', as: :super_admin

  resources :accounts

  root 'public_pages#home'
end

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
