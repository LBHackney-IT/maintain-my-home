source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'faker' # Use in all environments until we have a real API
gem 'faraday'
gem 'faraday_middleware'
gem 'flipper'
gem 'flipper-redis'
gem 'govuk_elements_rails'
gem 'govuk_frontend_toolkit'
gem 'haml-rails'
gem 'high_voltage', '~> 3.0.0'
gem 'jquery-rails'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.3'
gem 'redis-namespace'
gem 'sass-rails', '~> 5.0'
gem 'simple_form'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rubocop', '~> 0.49.1' # Locked because minor versions might change cops
end

group :development do
  gem 'i18n-debug'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara'
  gem 'climate_control'
  gem 'launchy'
  gem 'poltergeist'
  gem 'simplecov', require: false
  gem 'webmock'
end

group :production do
  gem 'rails_12factor'
end
