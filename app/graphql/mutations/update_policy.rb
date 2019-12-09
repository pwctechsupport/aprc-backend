# frozen_string_literal: true

module Mutations
  class UpdatePolicy < Mutations::BaseMutation
    graphql_name "UpdatePolicy"

    argument :id, ID, required: true
    argument :title, String, required: false
    argument :description, String, required: false
    argument :policy_category_id, ID, required: false
    argument :it_system_ids, [ID], required: false
    argument :resource_ids, [ID], required: false
    argument :business_process_ids, [ID], required: false
    argument :parent_id, ID, required: false
    argument :reference_ids, [ID], required: false

    field :policy, Types::PolicyType, null: false

    def resolve(id:, **args)
      policy = Policy.find(id)
      success = policy.update_attributes(args.to_h)

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