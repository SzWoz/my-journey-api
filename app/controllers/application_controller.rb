class ApplicationController < ActionController::Base
  include Pundit::Authorization
  protect_from_forgery with: :null_session, if: -> { request.format.json? }

  before_action :authenticate_user!

  def current_user
    @current_user ||= authenticate_user_from_token
  end

  private

  def authenticate_user_from_token
    token = request.headers['Authorization']&.split(' ')&.last
    return nil unless token

    decoded_token = JWT.decode(token, Rails.application.credentials.fetch(:secret_key_base), true,
                               { algorithm: 'HS256' })

    binding.pry

    user_id = decoded_token[0]['sub'].to_i
    User.find_by(id: user_id)
  rescue JWT::DecodeError
    nil
  end
end
