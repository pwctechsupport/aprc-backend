# frozen_string_literal: true

module Mutations
  class UpdatePolicyCategory < Mutations::BaseMutation
    graphql_name "UpdatePolicyCategory"

    argument :id, ID, required: true
    argument :name, String, required: false


    field :policy_category, Types::PolicyCategoryType, null: false

    def resolve(id:, **args)
      policy_category = PolicyCategory.find(id)
      success = policy_category.update_attributes(args.to_h)

      MutationResult.call(
        obj: { policy_category: policy_category },
        success: policy_category.persisted?,
        errors: policy_category.errors
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