Rails.application.routes.draw do
  devise_for :users

  root to: "costumes#index"

  resources :costumes, only: %i[index show new create edit update destroy] do
    resources :bookings, only: %i[new create edit update destroy]
    resources :reviews, only: %i[create]
  end

  get '/my_costumes', to: 'costumes#my_costumes'
  get '/my_bookings', to: 'bookings#my_bookings' 
  get '/wordsearch', to: 'costumes#search'
  resources :users, only: %i[index]
  get '/costumes/:costume_id/bookings/:id/accept', to: 'bookings#accept', as: "accept"

end
