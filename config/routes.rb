Rails.application.routes.draw do
  resource :address_search, only: %i[new create]
  resource :address, only: [:create]
  resources :appointments, only: [:new]

  root to: 'start#index'
end
