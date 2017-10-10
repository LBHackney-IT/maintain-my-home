Rails.application.routes.draw do
  get '/address-search', to: 'address_searches#index', as: 'address_search'
  post '/address-search', to: 'address_searches#create'

  resource :address, only: [:create]
  resources :confirmations, only: [:show]

  namespace :questions do
    get '/start', to: 'start#index', as: 'start'
    post '/start', to: 'start#submit'
  end

  get '/questions/:id', to: 'questions#show', as: 'questions'
  post '/questions/:id', to: 'questions#submit'

  get '/describe-repair', to: 'describe_repair#index', as: 'describe_repair'
  post '/describe-repair', to: 'describe_repair#submit'

  get '/describe-unknown-repair',
      to: 'describe_unknown_repair#index',
      as: 'describe_unknown_repair'
  post '/describe-unknown-repair', to: 'describe_unknown_repair#submit'

  get '/contact-details', to: 'contact_details#index', as: 'contact_details'
  post '/contact-details', to: 'contact_details#submit'
end
