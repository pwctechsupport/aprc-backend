# frozen_string_literal: true

module Mutations
  class UpdateResource < Mutations::BaseMutation
    graphql_name "UpdateResource"

    argument :id, ID, required: true
    argument :name, String, required: false
    argument :resuploadBase64, String, as: :resupload, required: false
    argument :resuploadFileName, String, as: :resupload_file_name, default_value: 'resupload', required: false  
    argument :category, Types::Enums::Category, required: false 
    argument :policy_ids, [ID], required: false 
    argument :control_ids, [ID], required: false 
    argument :policy_id, ID, required: false
    argument :control_id, ID, required: false
    argument :business_process_id, ID, required: false 
    argument :status, Types::Enums::Status, required: false



    field :resource, Types::ResourceType, null: false

    def resolve(id:, **args)
      resource = Resource.find(id)
      success = resource.update_attributes(args.to_h)

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

    # def ready?(args)
    #   authorize_user
    # end
  end
end