#frozen_string_literal: true

module Mutations
  class DestroyFileAttachment < Mutations::BaseMutation
    graphql_name "DestroyFileAttachment"
    argument :ids, [ID], required: true

    field :file_attachment, Boolean, null: false

    def resolve(ids:)
      file_attachment = FileAttachment.where(id: ids)
      success = file_attachment.destroy_all

      MutationResult.call(
        obj: {file_attachment: file_attachment},
        success: success,
        errors: success
      )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(',')}"
      )
    end

    def ready?(args)
      authorize_user
    end

  end
end
