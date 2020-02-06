# frozen_string_literal: true

module Mutations
  class IsRead < Mutations::BaseMutation
    graphql_name "IsRead"

    argument :id, ID, required: true

    field :notification, Boolean, null: false

    def resolve(id:)
      notification = Notification.find(id)
      success = notification.update!(is_read: true)
      MutationResult.call(
        obj: { notification: notification },
        success: success,
        errors: success
      )

    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
      
    end

    def ready?(args)
      authorize_user
    end
  end
end