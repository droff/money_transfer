require 'rails_helper'

describe '/api/v1/accounts', type: :request do
  let(:name) { 'John Doe' }
  let(:email) { 'john.doe@example.com' }
  let(:account) { create(:account, id: 1, name: name, email: email) }
  let(:headers) { { APIController::X_SECURE_USER_ID => account.id } }

  describe 'check header' do
    it 'returns forbidden error if current account not found' do
      get '/me', params: {}, headers: { APIController::X_SECURE_USER_ID => 1_000_000 }

      expect(response).to have_http_status(403)
      expect(response.parsed_body).to eq(
        'error' => 'Forbidden'
      )
    end
  end

  describe 'GET /me' do
    before { account }

    it 'returns account' do
      get '/me', params: {}, headers: headers

      expect(response).to have_http_status(200)
      expect(response.content_type).to start_with('application/json')
      expect(response.parsed_body).to eq(
        'id' => account.id,
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
        'error' => { 'email' => [ 'has already been taken' ] }
      )
    end
  end

  describe 'POST /transfer' do
    let(:receiver_account) { create(:account, id: 2, name: 'Receiver', email: 'receiver@example.com') }
    let(:transfer_params) { { receiver_user_id: receiver_account.id, amount: 50 } }

    it 'transfers money' do
      account.update(balance: 100)
      post '/transfer', params: transfer_params, headers: headers

      expect(response).to have_http_status(200)
      expect(response.parsed_body).to eq(
        'message' => 'Transfer successful',
        'sender_balance' => account.reload.balance,
        'receiver_balance' => receiver_account.reload.balance
      )
    end

    it 'returns an error for insufficient balance' do
      account.update(balance: 0)
      post '/transfer', params: transfer_params, headers: headers

      expect(response).to have_http_status(400)
      expect(response.parsed_body).to eq(
        'error' => 'Insufficient balance'
      )
    end
  end

  describe 'POST /deposit' do
    let(:amount) { 100 }
    let(:deposit_params) { { whop_bank_token: WHOP::Bank::DEPOSIT_TOKENS[amount], amount: amount.to_s } }
    let(:uri) { "#{WHOP::Client::API_URL}/deposit" }

    before do
      stub_request(:post, uri)
        .with(body: deposit_params, headers: { 'Content-Type': 'application/json' })
        .to_return(status: 200)
    end

    it 'deposits money' do
      post '/deposit', params: deposit_params, headers: headers

      expect(response).to have_http_status(200)
      expect(response.parsed_body).to eq(
        'message' => 'Deposit successful',
        'balance' => account.reload.balance
      )
    end

    it 'returns an error for wrong token' do
      post '/deposit', params: { whop_bank_token: 'invalid-token', amount: '10' }, headers: headers

      expect(response).to have_http_status(400)
      expect(response.parsed_body).to eq(
        'error' => 'Invalid bank token'
      )
    end
  end

  describe 'POST /withdraw' do
    let(:amount) { 50 }
    let(:withdraw_params) { { whop_bank_token: WHOP::Bank::WITHDRAW_TOKENS[amount], amount: amount.to_s } }
    let(:uri) { "#{WHOP::Client::API_URL}/withdraw" }

    before do
      account.update(balance: 100)
      stub_request(:post, uri)
        .with(body: withdraw_params, headers: { 'Content-Type': 'application/json' })
        .to_return(status: 200)
    end

    it 'withdraws money' do
      post '/withdraw', params: withdraw_params, headers: headers

      expect(response).to have_http_status(200)
      expect(response.parsed_body).to eq(
        'message' => 'Withdrawal successful',
        'balance' => account.reload.balance
      )
    end

    it 'returns an error for wrong token' do
      post '/withdraw', params: { whop_bank_token: 'invalid-token', amount: '10' }, headers: headers

      expect(response).to have_http_status(400)
      expect(response.parsed_body).to eq(
        'error' => 'Invalid bank token'
      )
    end
  end
end
