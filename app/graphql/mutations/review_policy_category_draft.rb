module Mutations
  class ReviewPolicyCategoryDraft < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :publish, Boolean, required: true
    argument :id, ID, required: true
    
    # return type from the mutation
    field :policy_category, Types::PolicyCategoryType, null: true

    def resolve(args)
      current_user = context[:current_user]
      policy_category = PolicyCategory.find(args[:id])

      if current_user.present? && current_user.has_role?(:admin)
        policy_category_draft = policy_category.draft
        if args[:publish] === true
          if policy_category.user_reviewer_id.present? && (policy_category.user_reviewer_id != current_user.id)
            raise GraphQL::ExecutionError, "This Draft has been reviewed by another Admin."
          elsif !policy_category.user_reviewer_id.present?
            policy_category_draft.publish!
            policy_category.update(user_reviewer_id: current_user.id)
          else
            policy_category_draft.publish!
            policy_category.update(user_reviewer_id: current_user.id)
          end
        else
          if policy_category.user_reviewer_id.present? && (policy_category.user_reviewer_id != current_user.id)
            raise GraphQL::ExecutionError, "This Draft has been reviewed by another Admin."
          end
          policy_category_draft.revert!
        end 
      else
        raise GraphQL::ExecutionError, "User is not an Admin."
      end

      # policy_category = Policy_category.create!(args.to_h)
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