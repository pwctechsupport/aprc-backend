module Api
  class PolicyCategoriesController < ApiController
    def import
      status, error_data = current_user.present? ? PolicyCategory.import(params[:file], current_user) : PolicyCategory.import(params[:file])
      im = Import.create(name: "Policy Category", file: params[:file])
      if status
      	render json: { status: 200, message: "Succesfully import file risk. #{im.errors.full_messages.join(', ')}", error_data: error_data.as_json}
      else
      	render json: { status: 422, message: "Failed import file risk. #{im.errors.full_messages.join(', ')}"}
      end
    end
  end
end