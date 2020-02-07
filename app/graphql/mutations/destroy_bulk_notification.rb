#frozen_string_literal: true
module Mutations
  class DestroyBulkNotification < Mutations::BaseMutation
    graphql_name "DestroyBulkNotification"

    argument :ids, [ID], required: true

    field :notification, Boolean, null: true

    def resolve(ids:)
      notification = Notification.where(id:ids)
      success = notification.destroy_all

      MutationResult.call(
        obj: { notification: notification },
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