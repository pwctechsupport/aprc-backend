module Api
  class ControlsController < ApiController
    def import
      status, error_data = current_user.present? ? Control.import(params[:file], current_user) : Control.import(params[:file]) 
      if status
      	render json: { status: 200, message: "Succesfully import file control", error_data: error_data.as_json}
      else
      	render json: { status: 422, message: "Failed import file control"}
      end
    end
  end
end