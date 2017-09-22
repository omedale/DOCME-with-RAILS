Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :roles
  
  resources :users do
    resources :documents
  end

  post 'authenticate', to: 'authentication#authenticate'

  post 'login', to: 'users#login_user'
  post 'register', to: 'users#register'

end
