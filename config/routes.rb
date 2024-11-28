Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  # accounts
  get 'me' => 'api/v1/accounts#me'
  post 'create_account' => 'api/v1/accounts#create'
end
