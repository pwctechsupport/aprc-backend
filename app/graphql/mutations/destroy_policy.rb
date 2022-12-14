# frozen_string_literal: true

module Mutations
  class DestroyPolicy < Mutations::BaseMutation
    graphql_name "DestroyPolicy"

    argument :id, ID, required: true

    field :policy, Types::PolicyType, null: false

    def resolve(id:)
      policy = Policy.find(id)
      success = policy.destroy
      
      MutationResult.call(
        obj: { policy: policy },
        success: success,
        errors: policy.errors
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