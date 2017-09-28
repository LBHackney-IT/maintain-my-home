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

  get '/address-isnt-here',
      to: 'pages#address_isnt_here',
      as: 'address_isnt_here'

  get '/describe-repair', to: 'describe_repair#index', as: 'describe_repair'
  post '/describe-repair', to: 'describe_repair#submit'

  root to: 'start#index'
end
