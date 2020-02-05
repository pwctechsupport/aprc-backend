module Mutations
  class CreateUserAccess < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :user_id, ID, required: true
    argument :role_ids, [ID], required: true
    argument :policy_category_ids, [ID], required: true

    # return type from the mutation
    field :user_policy_category, Types::UserPolicyCategoryType, null: true

    def resolve(user_id:, **args)
      user_policy_category = User.find(user_id)
      user_policy_category.update_attributes!(args.to_h)
      
      MutationResult.call(
          obj: { user_policy_category: user_policy_category },
          success: user_policy_category.persisted?,
          errors: user_policy_category.errors
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