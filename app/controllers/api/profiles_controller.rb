module Api
  class ProfilesController < ApplicationController
    include Pundit

    before_action :set_current_user

    def show
      if @current_user
        authorize @current_user
        render json: @current_user, status: :ok
      else
        render json: { error: 'User not found' }, status: :not_found
      end
    end

    private

    def set_current_user
      @current_user = current_user
    end
  end
end
