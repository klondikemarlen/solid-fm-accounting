module Api
  class CurrentUserController < Api::BaseController
    def show
      render json: {
        id: current_user.id,
        email: current_user.email,
        displayName: current_user.display_name
      }
    end
  end
end
