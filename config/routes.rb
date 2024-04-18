Rails.application.routes.draw do
  get 'users/new'
  get 'users/create'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  root 'samples#index'
end
