module Manager
  class BaseController < ApplicationController
    before_action :authorize_manager!

    private

    def authorize_manager!
      return if current_user&.role.in?(%w[manager admin])

      redirect_to root_path, alert: "You are not authorized to access this area."
    end
  end
end
