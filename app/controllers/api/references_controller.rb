module Api
  class ReferencesController < ApiController
    def import
      if Reference.import(params[:file])
      	render json: { status: 200, message: "Succesfully import file business process"}
      else
      	render json: { status: 422, message: "Failed import file business process"}
      end
    end
  end
end