class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  private

  def respond_with(resource, _opts = {})
    register_success && return if resource.persisted?

    register_failed
  end

  def register_success
    render json: { message: 'Signed up successfully.' }
  end

  def register_failed
    render json: { message: 'Something went wrong.' }
  end

  def set_flash_message!(*)
    # Override to disable flash messages
  end
end
