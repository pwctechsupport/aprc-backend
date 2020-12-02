module Api
  class ResourcesController < ApiController
    def import
      status, error_data = Resource.import(params[:file])
      Import.create(name: "Resource", file: params[:file])
      if status
      	render json: { status: 200, message: "Succesfully import file business process", error_data: error_data.as_json}
      else
      	render json: { status: 422, message: "Failed import file business process"}
      end
    end
  end
end