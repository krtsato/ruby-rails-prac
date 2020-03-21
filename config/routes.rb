Rails.application.routes.draw do
  namespace :admin do
    root 'top#index'
    get 'login' => 'session#new', as: :login
    resource :session, only: [:create, :destroy]
  end
  
  namespace :staff do
    root 'top#index'
    get 'login' => 'sessions#new', as: :login
    resource :session, only: [:create, :destroy]
  end 
  
  namespace :customer do
    root 'top#index'
  end
end
