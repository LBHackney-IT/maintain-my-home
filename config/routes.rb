Rails.application.routes.draw do
  resource :address_search, only: :show
  resource :addresses, only: [:update]
  resources :appointments, only: [:new]

  root to: 'start#index'
end
