# frozen_string_literal: true

module Mutations
  class PushNotification < Mutations::BaseMutation
    graphql_name "PushNotification"

    argument :id, ID, required: true

    field :user, Boolean, null: true

    def resolve(id:)
      user = User.find(id)
      success = user.update!(push_notification: true)
      MutationResult.call(
        obj: { user: user },
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