Rails.application.routes.draw do
  resource :address_search, only: %i[show update]
  resource :addresses, only: [:update]
  resources :appointments, only: [:new]

  root to: 'start#index'
end
