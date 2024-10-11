class Users::SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        status: 200,
        message: 'Logged in successfully',
        user: resource
      }, status: :ok
    else
      render json: {
        status: 401,
        message: 'Invalid email or password'
      }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    if current_user
      render json: {
        status: 200,
        message: 'Logged out successfully'
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
