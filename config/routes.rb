Rails.application.routes.draw do
  root 'tasks#index'
  get '/signup', to: 'sessions#new'
  post '/signup', to: 'sessions#create'
  get '/login', to: 'sessions#login', as: :login
  post '/login', to: 'sessions#authenticate'
  delete '/logout', to: 'sessions#destroy', as: :logout

  resources :tasks
end
