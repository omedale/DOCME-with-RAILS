Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: redirect("https://docme.herokuapp.com")

  scope module: :v2, constraints: ApiVersion.new('v2') do
    resources :users, only: :index
  end
  
  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    resources :roles
    resources :users do
      collection do 
        get 'search/', :action => 'search', :as => 'search'
      end
      resources :documents do
        collection do 
          get 'search/', :action => 'search', :as => 'search'
        end
      end
    end
  end


  post 'verifyaccess', to: 'index#verifyaccess'
  post 'get-user-id', to: 'index#get_user_id'

  post 'login', to: 'index#login_user'
  post 'register', to: 'index#register'

  match '/(*url)', to: 'not_found#index', via: :all
end
