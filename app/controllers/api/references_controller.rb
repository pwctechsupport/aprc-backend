module Api
  class ReferencesController < ApiController
    def import
      status, error_data = current_user.present? ? Reference.import(params[:file], current_user) : Reference.import(params[:file])
      if status
        Import.create(name: "Reference", file: params[:file])
      	render json: { status: 200, message: "Succesfully import file references", error_data: error_data.as_json}
      else
      	render json: { status: 422, message: "Failed import file references"}
      end
    end
  end
end