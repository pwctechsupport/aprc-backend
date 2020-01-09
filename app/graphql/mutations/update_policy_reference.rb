# frozen_string_literal: true

module Mutations
  class UpdatePolicyReference < Mutations::BaseMutation
    graphql_name "UpdatesubPolicyReference"

    argument :id, ID, required: true
    argument :title, String, required: false
    argument :description, String, required: false
    argument :parent_id, ID, required: true
    argument :reference_ids, [ID], required: false

    field :policy, Types::PolicyType, null: false

    def resolve(id:, **args)
      policy = Policy.find(id)
      policy.update_attributes!(args.to_h)

      MutationResult.call(
        obj: { policy: policy },
        success: policy.persisted?,
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