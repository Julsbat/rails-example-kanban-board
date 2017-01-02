Rails.application.routes.draw do
  root 'boards#index'

  resources :cards
  resources :boards
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end



