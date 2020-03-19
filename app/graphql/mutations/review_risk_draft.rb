module Mutations
  class ReviewRiskDraft < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :publish, Boolean, required: true
    argument :id, ID, required: true
    
    # return type from the mutation
    field :risk, Types::RiskType, null: true

    def resolve(args)
      current_user = context[:current_user]
      risk = Risk.find(args[:id])

      if current_user.present? && current_user.has_role?(:admin_reviewer)
        risk_draft = risk.draft
        admin_prep = User.with_role(:admin_preparer).pluck(:id)
        if args[:publish] === true
          if risk.user_reviewer_id.present? && (risk.user_reviewer_id != current_user.id)
            raise GraphQL::ExecutionError, "This Draft has been reviewed by another Admin."
          elsif !risk.user_reviewer_id.present?
            risk_draft.publish!
            risk.update(user_reviewer_id: current_user.id)
            risk.update(status: "release" )
            Notification.send_notification(admin_prep, "Risk Draft named #{risk&.name} Approved", risk&.name,risk, current_user&.id, "request_draft_approved")
          else
            risk_draft.publish!
            risk.update(user_reviewer_id: current_user.id)
            risk.update(status: "release" )
            Notification.send_notification(admin_prep, "Risk Draft named #{risk&.name} Approved", risk&.name,risk, current_user&.id, "request_draft_approved")
          end
        else
          if risk.user_reviewer_id.present? && (risk.user_reviewer_id != current_user.id)
            raise GraphQL::ExecutionError, "This Draft has been reviewed by another Admin."
          else
            Notification.send_notification(admin_prep, "Risk Draft named #{risk&.name} Rejected", risk&.name,risk, current_user&.id, "request_draft_rejected")
            risk_draft.revert!
          end
        end 
      else
        raise GraphQL::ExecutionError, "User is not an Admin."
      end

      # risk = risk.create!(args.to_h)
      MutationResult.call(
          obj: { risk: risk },
          success: risk.persisted?,
          errors: risk.errors
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