class APIController < ApplicationController
  skip_forgery_protection

  X_SECURE_USER_ID = 'x-secure-user-id'.freeze

  private

  def current_account
    @current_account ||= Account.find_by(id: user_id)
  end

  def check_current_account
    unless current_account
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end

  def user_id
    request.headers[X_SECURE_USER_ID]
  end

  def render_error(message)
    render json: { error: message }, status: :bad_request
  end
end
