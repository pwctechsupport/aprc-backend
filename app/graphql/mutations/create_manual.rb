module Mutations
  class CreateManual < Mutations::BaseMutation
    argument :name, String, required: false
    argument :resuploadBase64, String, as: :resupload, required: false
    argument :resuploadFileName, String, as: :resupload_file_name, required: false

    field :manual, Types::ManualType, null: true

    def resolve(args)
      current_user = context[:current_user]
      args[:user_id] = current_user&.id
      if Manual.count < 1
        if current_user.has_role?(:admin_reviewer)
          manual = Manual.create!(args.to_h)
          if args[:resupload].present?
            args[:resupload_file_name] = "#{args[:name]}" << manual.resource_file_type(manual)
            manual.update_attributes(resupload: args[:resupload], resupload_file_name: args[:resupload_file_name])
          end
        else
          raise GraphQL::ExecutionError ,"Only User with role \"Admin Reviewer\" can Upload the user manual"
        end
      else
        raise GraphQL::ExecutionError ,"A manual has already existed. You can either update or delete the existing manual"
      end
      # request_edit = current_user.request_edit_risks.create!(args.to_h)
      MutationResult.call(
        obj: {manual: manual},
        success: manual.persisted?,
        errors: manual.errors
      )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end

    def ready?(args)
      authorize_user
    end

  end
end