# frozen_string_literal: true

Rails.application.routes.draw do
  resources :luster7s
  resources :luster6s
  resources :luster5s
  resources :luster4s
  resources :luster3s
  resources :luster2s
  get 'static_pages/home'
  get 'static_pages/help'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'static_pages#home'
end
