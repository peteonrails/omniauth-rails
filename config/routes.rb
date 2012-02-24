Rails.application.routes.draw do
  match "/login" => "authentications#signin", :as => :login
  match "/logout" => "authentications#signout", :as => :logout
  match '/auth/:provider/callback' => 'authentications#create'
  match '/auth/failure' => 'authentications#failure'
  
  resources :authentications, :only => [:index, :create, :destroy] do
    collection do
      get 'signin'
      get 'signout'
      get 'signup'
      post 'newaccount'
      get 'failure'
    end
  end
end