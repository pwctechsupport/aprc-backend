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

      if current_user.present? && current_user.has_role?(:admin_reviewer)
        policy_category_draft = policy_category.draft
        admin_prep = User.with_role(:admin_preparer).pluck(:id)
        if args[:publish] === true
          if policy_category.user_reviewer_id.present? && (policy_category.user_reviewer_id != current_user.id)
            raise GraphQL::ExecutionError, "This Draft has been reviewed by another Admin."
          else
            if policy_category_draft.event == "update"
              serial = ["policy"]
              serial.each do |sif|
                if policy_category_draft.changeset[sif].present?
                  policy_category_draft.changeset[sif].map!{|x| JSON.parse(x)}
                end
              end
            end
            policy_category_draft.reify
            policy_category_draft.publish!
            policy_category.update(user_reviewer_id: current_user.id, status: "release", is_related: false)
            Notification.send_notification(admin_prep, "Policy Category Draft named #{policy_category.name} Approved", policy_category&.name,policy_category, current_user&.id, "request_draft_approved")
          end
          if policy_category&.present? && policy_category&.request_edit&.present?
            policy_category&.request_edit&.destroy
          end
        else
          if policy_category.user_reviewer_id.present? && (policy_category.user_reviewer_id != current_user.id)
            raise GraphQL::ExecutionError, "This Draft has been reviewed by another Admin."
          else
            Notification.send_notification(admin_prep, "Policy Category Draft named #{policy_category.name} Rejected", policy_category&.name,policy_category, current_user&.id, "request_draft_rejected")
            policy_rejected = policy_category&.policy
            policy_category_draft.revert!
            if policy_category&.present?
              policy_category&.update(is_related:false)
            end
            if policy_category&.present? && policy_category&.request_edit&.present?
              policy_category&.request_edit&.destroy
              policy_category.update(policy: policy_rejected)
            end
          end
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