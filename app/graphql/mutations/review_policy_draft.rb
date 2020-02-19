module Mutations
  class ReviewPolicyDraft < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :publish, Boolean, required: true
    argument :id, ID, required: true
    
    # return type from the mutation
    field :policy, Types::PolicyType, null: true

    def resolve(args)
      current_user = context[:current_user]
      policy = Policy.find(args[:id])

      if current_user.present? && current_user.has_role?(:admin_reviewer)
        policy_draft = policy.draft
        if args[:publish] === true
          policy_draft.publish!
          policy.update(status: "release")
          policy.update(user_reviewer_id: current_user.id)
        else
          policy_draft.revert!
        end 
      else
        raise GraphQL::ExecutionError, "User is not an Admin."
      end

      # policy = Policy.create!(args.to_h)
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