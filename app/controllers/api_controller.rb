class ApiController < ActionController::Base
  # # # attr_accessor :current_api_user
  # before_action :authenticate_user!
  # before_action :load_user

  # private

  # def load_user
  #   unless current_user.present?
  #     render json: {status: 401, messages: "Invalid Token."}, status: 401
  #   end
  # end
end
