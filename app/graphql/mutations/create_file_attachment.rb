module Mutations
  class CreateFileAttachment < Mutations::BaseMutation
    argument :originator_id, ID, required: true
    argument :originator_type, String, required: true
    argument :resuploadBase64, String, as: :resupload, required: false
    argument :resuploadFileName, String, as: :resupload_file_name, default_value: 'resupload', required: false
    argument :user_id, ID, required: false


    field :file_attachment, Types::FileAttachmentType, null: true

    def resolve(args)
      current_user = context[:current_user]
      args[:user_id] = current_user.id
      file_attachment = FileAttachment.create!(args.to_h)
      # request_edit = current_user.request_edit_risks.create!(args.to_h)
      MutationResult.call(
        obj: {file_attachment: file_attachment},
        success: file_attachment.persisted?,
        errors: file_attachment.errors
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