module Mutations
  class UpdateActivityControl < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :activity, String, required: false
    argument :guidance, String, required: false
    argument :resuploadBase64, String, as: :resupload, required: false
    argument :resupload, ApolloUploadServer::Upload, required: false
    argument :resuploadFileName, String, as: :resupload_file_name, default_value: 'resupload', required: false

    field :activity_control, Types::ActivityControlType, null: true

    def resolve(id:, **args)
      current_user = context[:current_user]
      args[:user_id] = current_user&.id
      activity_control = ActivityControl.find(id)
      args[:control_id] = activity_control&.control_id
      if args[:guidance].present? && (args[:resupload].present? || args[:resuploadFileName.present?])
        raise GraphQL::ExecutionError, "Guidance can only provide one type of Guidance: Attachment or Text" 
      else
        if args[:guidance]&.present? && (activity_control&.resupload&.present?)
          activity_control&.resupload&.destroy
          activity_control&.update_attributes!(args.to_h)
          activity_control.update(is_attachment: false)
        elsif args[:resupload]&.present? && activity_control&.guidance&.present?
          activity_control&.guidance&.destroy
          activity_control&.update_attributes!(args.to_h)
          activity_control.update(is_attachment: true)
        else
          activity_control&.update_attributes!(args.to_h)
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