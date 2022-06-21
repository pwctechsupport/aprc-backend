module Mutations
  class CreateTag < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :body, String, required: false
    argument :resource_id, ID, required: true
    argument :business_process_id, ID, required: true
    argument :x_coordinates, Int, required: false
    argument :y_coordinates, Int, required: false
    argument :control_id, ID, required: false
    argument :risk_id, ID, required: false
    argument :user_id, ID, required: false

    # return type from the mutation
    field :tag, Types::TagType, null: true

    def resolve(args)
      current_user = context[:current_user]
      args[:user_id] = current_user.id
      resource = Resource.find(args[:resource_id].to_i)
      args[:image_name] = resource.resupload_file_name
      if args[:control_id].present?
        tag = (Tag.find_by(resource_id: args[:resource_id],business_process_id: args[:business_process_id],control_id: args[:control_id])) 
        if !(tag.present?)
          tag = Tag.create!(args.to_h)
        else
          raise GraphQL::ExecutionError, "This Control has been Selected to another tag."
        end
      elsif args[:risk_id].present?
        tag = Tag.find_by(resource_id: args[:resource_id],business_process_id: args[:business_process_id],risk_id: args[:risk_id])
        if !(tag.present?)
          tag = Tag.create!(args.to_h)
        else
          raise GraphQL::ExecutionError, "This Risk has been Selected to another tag."
        end
      end
      
      MutationResult.call(
          obj: { tag: tag },
          success: tag.persisted?,
          errors: tag.errors
        )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end
  end
end