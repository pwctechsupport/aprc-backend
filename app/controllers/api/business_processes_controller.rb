module Api
  class BusinessProcessesController < ApiController
    def import
      status, error_data = current_user.present? ? BusinessProcess.import(params[:file], current_user) : BusinessProcess.import(params[:file])
      Import.create(name: "Business Process", file: params[:file])
      if status
      	render json: { status: 200, message: "Succesfully import file Business Process", error_data: error_data.as_json}
      else
      	render json: { status: 422, message: "Failed import file Business Process"}, status: 422
      end
    end
  end
end