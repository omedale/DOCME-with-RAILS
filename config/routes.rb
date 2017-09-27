Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: redirect("https://docme.herokuapp.com")

  resources :roles

  resources :users do
    resources :documents
  end

  post 'authenticate', to: 'authentication#authenticate'

  post 'login', to: 'users#login_user'
  post 'register', to: 'users#register'

  match '/(*url)', to: 'not_found#index', via: :all
end
