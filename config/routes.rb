Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  get 'me' => 'api/v1/accounts#me'
  post 'create_account' => 'api/v1/accounts#create'
  post '/transfer' => 'api/v1/accounts#transfer'
  post '/deposit' => 'api/v1/accounts#deposit'
end
