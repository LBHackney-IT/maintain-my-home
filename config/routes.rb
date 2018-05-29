Rails.application.routes.draw do
  get '/landing', to: 'landing_page#index'

  get '/address-search', to: 'address_searches#index', as: 'address_search'
  post '/address-search', to: 'address_searches#create'
  delete '/address-search', to: 'address_searches#destroy', as: 'destroy_address_search'

  resource :address, only: [:create]
  resources :confirmations, only: [:show]

  namespace :questions do
    get '/start', to: 'start#index', as: 'start'
    post '/start', to: 'start#submit'
    get '/screening_filter', to: 'screening_filter#index', as: 'screening_filter'
    post '/screening_filter', to: 'screening_filter#submit'
  end

  get '/questions/:id', to: 'questions#show', as: 'questions'
  post '/questions/:id', to: 'questions#submit'

  get '/describe-repair', to: 'describe_repair#index', as: 'describe_repair'
  post '/describe-repair', to: 'describe_repair#submit'

  get '/contact-details', to: 'contact_details#index', as: 'contact_details'
  post '/contact-details', to: 'contact_details#submit'

  get '/contact-details-with-callback',
      to: 'contact_details_with_callback#index',
      as: 'contact_details_with_callback'
  post '/contact-details-with-callback',
       to: 'contact_details_with_callback#submit'

  get '/appointments/:repair_request_reference',
      to: 'appointments#show',
      as: 'appointments'
  post '/appointments/:repair_request_reference',
       to: 'appointments#submit'

  # Feature flags
  flipper_app = Flipper::UI.app(App.flipper) do |builder|
    builder.use Rack::Auth::Basic do |username, password|
      username == ENV['FLIPPER_AUTH_USER'] &&
        password == ENV['FLIPPER_AUTH_PASSWORD']
    end
  end

  mount flipper_app, at: '/feature_flags'
end
