#frozen_string_literal: true

module Mutations
  class DestroyNotification < Mutations::BaseMutation
    graphql_name "DestroyNotification"
    argument :id, ID, required: true

    field :notification, Types::NotificationType, null: false

    def resolve(id:)
      notification = Notification.find(id)
      success = notification.destroy

      MutationResult.call(
        obj: {notification: notification},
        success: success,
        errors: notification.errors
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
