module Mutations
  class AdminUpdateUser < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :user_id, ID, required: true
    argument :first_name, String, required: false
    argument :last_name, String, required: false
    argument :role_ids, [ID], required: true
    argument :policy_category_ids, [ID], required: true

    # return type from the mutation
    field :user, Types::UserType, null: true

    def resolve(user_id:, **args)
      user = User.find(user_id)
      user.update_attributes!(args.to_h)
      
      MutationResult.call(
          obj: { user: user },
          success: user.persisted?,
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