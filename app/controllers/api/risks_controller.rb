module Api
  class RisksController < ApiController
    def import
      if Risk.import(params[:file])
      	render json: { status: 200, message: "Succesfully import file risk"}
      else
      	render json: { status: 422, message: "Failed import file risk"}
      end
    end
  end
end