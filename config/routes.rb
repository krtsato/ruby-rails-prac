Rails.application.routes.draw do
  namespace :admin do
    root to: 'top#index'
  end
  
  namespace :staff do
    root to: 'top#index'
  end 
  
  namespace :customer do
    root to: 'top#index'
  end
end
