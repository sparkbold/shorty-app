Rails.application.routes.draw do
  get 'categories/index'
  get 'categories/show'
  root 'urls#new'

  resources :urls, only: [:index, :new, :create]
  resources :users, only: [:index, :new, :create, :show]
  get "/urls/:short_url", to: "urls#show", as: 'shorten'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
