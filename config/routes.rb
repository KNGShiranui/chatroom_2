Rails.application.routes.draw do
  resources :users 
  resources :relationships, only: %i(create destroy)
  resources :sessions, only: %i(new create destroy)
  resources :conversations do
    resources :messages
  end
end
