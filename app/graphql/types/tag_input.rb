



class Types::TagInput  < Types::BaseInputObject
  argument :id, ID, required: false
  argument :body, String, required: false
  argument :resourceId, ID,as: :resource_id, required: false
  argument :businessProcessId, ID, as: :business_process_id,required: false
  argument :xCoordinates, Int,as: :x_coordinates, required: false
  argument :yCoordinates, Int,as: :y_coordinates,required: false
  argument :controlId, ID,as: :control_id,required: false
  argument :riskId, ID,as: :risk_id,required: false
  argument :userId, ID, as: :user_id, required: false
  argument :_destroy,Boolean, required: false
end

