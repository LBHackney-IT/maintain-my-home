Rails.application.routes.draw do
  resource :address_search, only: %i[new create]
  resource :address, only: [:create]
  resources :appointments, only: [:new]

  namespace :questions do
    get '/start', to: 'start#index', as: 'start'
    post '/start', to: 'start#submit', as: 'start_submit'
  end

  get '/emergency-contact',
      to: 'pages#emergency_contact',
      as: 'emergency_contact'

  root to: 'start#index'
end
