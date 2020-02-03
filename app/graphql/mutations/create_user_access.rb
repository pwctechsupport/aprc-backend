module Mutations
  class CreateUserAccess < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :user_id, ID, required: true
    argument :role_id, ID, required: true
    argument :policy_category_id, ID, required: true

    # return type from the mutation
    field :user_policy_category, Types::UserPolicyCategoryType, null: true

    def resolve(args)
      user = User.find_by(id: args[:user_id])
      user.update_attributes(role: args[:role_id].to_i)
      user_policy_category = UserPolicyCategory.create(user_id: user.id, policy_category_id: args[:policy_category_id])
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