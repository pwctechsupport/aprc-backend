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

      if current_user.present? && current_user.has_role?(:admin)
        risk_draft = risk.draft
        if args[:publish] === true
          if risk.user_reviewer_id.present? && (risk.user_reviewer_id != current_user.id)
            raise GraphQL::ExecutionError, "This Draft has been reviewed by another Admin."
          elsif !risk.user_reviewer_id.present?
            risk_draft.publish!
            risk.update(user_reviewer_id: current_user.id)
            risk.update(status: "release" )
          else
            risk_draft.publish!
            risk.update(user_reviewer_id: current_user.id)
            risk.update(status: "release" )
          end
        else
          if risk.user_reviewer_id.present? && (risk.user_reviewer_id != current_user.id)
            raise GraphQL::ExecutionError, "This Draft has been reviewed by another Admin."
          end
          risk_draft.revert!
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