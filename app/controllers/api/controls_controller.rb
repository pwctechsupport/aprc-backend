module Api
  class ControlsController < ApiController
    def import
      if Control.import(params[:file])
      	render json: { status: 200, message: "Succesfully import file control"}
      else
      	render json: { status: 422, message: "Failed import file control"}
      end
    end
  end
end