# frozen_string_literal: true

module Mutations
  class DestroyUser < Mutations::BaseMutation
    graphql_name "DestroyUser"

    argument :id, ID, required: true

    field :user, Types::UserType, null: false

    def resolve(id:)
      user = User.find(id)
      success = user.destroy
      
      MutationResult.call(
        obj: { user: user },
        success: success,
        errors: user.errors
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