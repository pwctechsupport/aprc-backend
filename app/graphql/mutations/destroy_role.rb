# frozen_string_literal: true

module Mutations
  class DestroyRole < Mutations::BaseMutation
    graphql_name "DestroyRole"

    argument :id, ID, required: true

    field :role, Types::RoleType, null: false

    def resolve(id:)
      role = Role.find(id)
      success = role.destroy
      
      MutationResult.call(
        obj: { role: role },
        success: success,
        errors: role.errors
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