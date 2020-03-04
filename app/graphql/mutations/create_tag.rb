module Mutations
  class CreateTag < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :body, String, required: false
    argument :resource_id, ID, required: false
    argument :business_process_id, ID, required: false
    argument :x_coordinates, Int, required: false
    argument :y_coordinates, Int, required: false


    # return type from the mutation
    field :tag, Types::TagType, null: true

    def resolve(args)
      current_user = context[:current_user]
      args[:user_id] = current_user&.id
      resource = Resource.find(args[:resource_id].to_i)
      args[:image_name] = resource.resupload_file_name
      tag = Tag.create!(args.to_h)
      
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