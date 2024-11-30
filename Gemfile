source 'https://rubygems.org'

gem 'rails', '~> 8.0.0'
gem 'propshaft'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'importmap-rails'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'jbuilder'
gem 'tzinfo-data', platforms: %i[ windows jruby ]
gem 'solid_cache'
gem 'solid_queue'
gem 'solid_cable'
gem 'bootsnap', require: false
gem 'kamal', require: false
gem 'thruster', require: false

# https://github.com/rails-api/active_model_serializers/pull/2482
gem 'active_model_serializers', github: 'rails-api/active_model_serializers', branch: '0-10-stable'
gem 'rest-client'

group :development, :test do
  gem 'debug', platforms: %i[ mri windows ], require: 'debug/prelude'
  gem 'brakeman', require: false
  gem 'rubocop-rails-omakase', require: false
  gem 'factory_bot_rails'
  gem 'sqlite3'
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'database_cleaner-active_record'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'simplecov', require: false
  gem 'webmock'
end
