require 'net/http'

module Mutations
  class CreateResource < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true
    argument :resuploadBase64, String, as: :resupload, required: false
    argument :resuploadFileName, String, as: :resupload_file_name, default_value: 'resupload', required: false
    argument :category, String, required: true
    argument :policy_id, ID, required: false
    argument :control_id, ID, required: false
    argument :policy_ids, [ID], required: false 
    argument :control_ids, [ID], required: false 
    argument :business_process_id, ID, required: false 
    argument :status, Types::Enums::Status, required: false
    argument :resuploadLink, String, as: :resupload, required: false

    # argument :type_of_control, Types::Enums::TypeOfControl, required: true



    # return type from the mutation
    field :resource, Types::ResourceType, null: true

    def resolve(args)
      if args[:resuploadLink].present?        
        args[:resupload] = URI.parse(args[:resuploadLink])
      end
      if args[:category].present?
        enum_list = EnumList&.find_by(category_type: "Category", name: args[:category]) || EnumList&.find_by(category_type: "Category", code: args[:category])
        if enum_list ==  nil
          kode = args[:category].gsub("_"," ").titlecase
          EnumList.create(name: args[:category], category_type: "Category", code: kode)
        end
        enum_list = EnumList&.find_by(category_type: "Category", name: args[:category]) || EnumList&.find_by(category_type: "Category", code: args[:category])
        args[:category] = enum_list&.code
      end
      resource=Resource.create!(args.to_h)
      
      resource = Resource.find_by(name: args[:name], category: args[:category])
      if args[:resupload_file_name].present?
        resource.update(resupload_file_name: args[:resupload_file_name])
      end
      if resource.category.downcase == "flowchart"
        resource.update(policy_id: nil)
        resource.update(policy_ids: nil)
        resource.update(control_id: nil)
        resource.update(control_ids: nil)
        resource
      else
        resource.update(business_process_id: nil)
        resource
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