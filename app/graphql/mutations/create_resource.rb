module Mutations
  class CreateResource < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true
    argument :resuploadBase64, String, as: :resupload, required: false
    argument :resuploadFileName, String, as: :resupload_file_name, default_value: 'resupload', required: false
    argument :category, Types::Enums::Category, required: true
    argument :policy_id, ID, required: false
    argument :control_id, ID, required: false
    argument :policy_ids, [ID], required: false 
    argument :control_ids, [ID], required: false 
    argument :business_process_id, ID, required: false 
    argument :status, Types::Enums::Status, required: false
    # argument :type_of_control, Types::Enums::TypeOfControl, required: true



    # return type from the mutation
    field :resource, Types::ResourceType, null: true

    def resolve(args)
      resource = Resource.find_by(name: args[:name], category: args[:category])
      if resource.present? && resource.category == "flowchart"
        resource.update_attributes(args.to_h)
        resource.update(policy_id: nil)
        resource.update(control_id: nil)
      elsif resource.present? && resource.category != "flowchart"
        resource.update_attributes(args.to_h)
        resource.update(business_process_id: nil)
      else
        resource=Resource.create!(args.to_h)
        resource = Resource.find_by(name: args[:name], category: args[:category])
        if resource.category == "flowchart"
          resource.update(policy_id: nil)
          resource.update(policy_ids: nil)
          resource.update(control_id: nil)
          resource.update(control_ids: nil)
          resource
        else
          resource.update(business_process_id: nil)
          resource
        end
      end

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