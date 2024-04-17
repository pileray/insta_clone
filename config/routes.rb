Rails.application.routes.draw do
  get 'sample/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "samples#index"
end
