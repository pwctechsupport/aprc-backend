# frozen_string_literal: true

module Mutations
  class NotifBadges < Mutations::BaseMutation
    graphql_name "NotifBadges"

    argument :notif_show,Boolean, required: true

    field :user, Types::UserType, null: false

    def resolve(args)
      current_user = context[:current_user]
      user = User.find(current_user.id)
      success = user.update!(args)
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