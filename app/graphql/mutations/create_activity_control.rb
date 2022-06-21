module Mutations
  class CreateActivityControl < Mutations::BaseMutation
    argument :control_id, ID, required: true
    argument :activity, String, required: false
    argument :guidance, String, required: false
    argument :resuploadBase64, String, as: :resupload, required: false
    argument :resupload, ApolloUploadServer::Upload, required: false
    argument :resuploadFileName, String, as: :resupload_file_name, default_value: 'resupload', required: false
    argument :user_id, ID, required: false

    field :activity_control, Types::ActivityControlType, null: true

    def resolve(args)
      current_user = context[:current_user]
      args[:user_id] = current_user.id
      
      if args[:guidance].present? && (args[:resupload].present? || args[:resuploadFileName].present?)
        raise GraphQL::ExecutionError, "Guidance can only provide one type of Guidance: Attachment or Text" 
      else
        if args[:guidance].present?
          activity_control = ActivityControl.create!(args.to_h)
        else
          activity_control = ActivityControl.create!(args.to_h)
          activity_control.update(is_attachment: true)
        end
      end
      
      # request_edit = current_user.request_edit_risks.create!(args.to_h)
      MutationResult.call(
        obj: {activity_control: activity_control},
        success: activity_control.persisted?,
        errors: activity_control.errors
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