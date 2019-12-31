module Mutations
  class CreateResource < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true
    argument :resuploadBase64, String, as: :resupload, required: false
    argument :resuploadFileName, String, as: :resupload_file_name, default_value: 'resupload', required: false
    argument :category, Types::Enums::Category, required: true 
    argument :policy_ids, [ID], required: false 
    argument :control_ids, [ID], required: false 
    argument :business_process_id, ID, required: false 
    argument :status, Types::Enums::Status, required: false
    # argument :type_of_control, Types::Enums::TypeOfControl, required: true



    # return type from the mutation
    field :resource, Types::ResourceType, null: true

    def resolve(args)
      resource = Resource.create(args.to_h)

      MutationResult.call(
        obj: { resource: resource },
        success: resource.persisted?,
        errors: resource.errors
      )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end
  end
end