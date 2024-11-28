require 'rails_helper'

describe '/api/v1/accounts', type: :request do
  let(:account_id) { 1 }
  let(:name) { 'John Doe' }
  let(:email) { 'john.doe@example.com' }
  let(:account) { create(:account, name: name, email: email) }
  let(:headers) { { APIController::X_SECURE_USER_ID => account_id } }

  describe 'GET /me' do
    before { account }

    it 'returns account' do
      get '/me', params: {}, headers: headers

      expect(response).to have_http_status(200)
      expect(response.content_type).to start_with('application/json')
      expect(response.parsed_body).to eq(
        'id' => 1,
        'name' => name,
        'email' => email,
        'balance' => 0
      )
    end
  end

  describe 'POST /create_account' do
    let(:account_params) { { name: name, email: email } }
    it 'creates account' do
      post '/create_account', params: account_params

      expect(response).to have_http_status(200)
      expect(response.content_type).to start_with('application/json')
      expect(response.parsed_body).to eq(
        'id' => 1,
        'name' => name,
        'email' => email,
        'balance' => 0
      )
    end

    it 'returns bad request on validation' do
      create(:account, name: name, email: email)
      post '/create_account', params: account_params

      expect(response).to have_http_status(400)
      expect(response.content_type).to start_with('application/json')
      expect(response.parsed_body).to eq(
        'email' => [ 'has already been taken' ]
      )
    end
  end
end
