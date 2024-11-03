class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  private

  def respond_with(resource, _opts = {})
    register_success && return if resource.persisted?

    register_failed(resource)
  end

  def register_success
    render json: { message: 'Signed up successfully.' }
  end

  def register_failed(resource)
    render json: { message: 'Something went wrong.', errors: resource.errors.full_messages },
           status: :unprocessable_entity
  end

  def set_flash_message!(*)
    # Override to disable flash messages
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :username, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :username)
  end
end
