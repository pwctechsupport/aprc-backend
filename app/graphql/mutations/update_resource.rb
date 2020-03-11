# frozen_string_literal: true

module Mutations
  class UpdateResource < Mutations::BaseMutation
    graphql_name "UpdateResource"

    argument :id, ID, required: true
    argument :name, String, required: false
    argument :resuploadBase64, String, as: :resupload, required: false
    argument :resuploadFileName, String, as: :resupload_file_name, default_value: 'resupload', required: false  
    argument :category, String, required: false 
    argument :policy_ids, [ID], required: false 
    argument :control_ids, [ID], required: false 
    argument :policy_id, ID, required: false
    argument :control_id, ID, required: false
    argument :business_process_id, ID, required: false 
    argument :status, Types::Enums::Status, required: false
    argument :resupload_link, String, required: false




    field :resource, Types::ResourceType, null: false

    def resolve(id:, **args)
      if args[:resupload_link].present?        
        args[:resupload] = URI.parse(args[:resupload_link])
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
      resource = Resource.find(id)
      resource.update_attributes!(args.to_h)
      if args[:resupload_file_name].present?
        resource.update(resupload_file_name: args[:resupload_file_name])
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

    # def ready?(args)
    #   authorize_user
    # end
  end
end