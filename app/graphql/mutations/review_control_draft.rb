module Mutations
  class ReviewControlDraft < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :publish, Boolean, required: true
    argument :id, ID, required: true
    
    # return type from the mutation
    field :control, Types::ControlType, null: true

    def resolve(args)
      current_user = context[:current_user]
      control = Control.find(args[:id])

      if current_user.present? && current_user.has_role?(:admin_reviewer)
        control_draft = control.draft
        admin_prep = User.with_role(:admin_preparer).pluck(:id)
        if args[:publish] === true
          if control.user_reviewer_id.present? && (control.user_reviewer_id != current_user.id)
            raise GraphQL::ExecutionError, "This Draft has been reviewed by another Admin."
          elsif !control.user_reviewer_id.present?
            control_draft.publish!
            control.update(user_reviewer_id: current_user.id)
            control.update(status: "release")
            Notification.send_notification(admin_prep, "Control Draft with owner #{control&.control_owner} Approved", control&.description,control, current_user&.id, "request_draft_approved")
          else
            control_draft.publish!
            control.update(user_reviewer_id: current_user.id)
            control.update(status: "release")
            Notification.send_notification(admin_prep, "Control Draft with owner #{control&.control_owner} Approved", control&.description,control, current_user&.id, "request_draft_approved")
          end
        else
          if control.user_reviewer_id.present? && (control.user_reviewer_id != current_user.id)
            raise GraphQL::ExecutionError, "This Draft has been reviewed by another Admin."
          else
            Notification.send_notification(admin_prep, "Control Draft with owner #{control&.control_owner} Rejected", control&.description,control, current_user&.id, "request_draft_rejected")
            control_draft.revert!
          end
        end 
      else
        raise GraphQL::ExecutionError, "User is not an Admin."
      end

      # control = control.create!(args.to_h)
      MutationResult.call(
          obj: { control: control },
          success: control.persisted?,
          errors: control.errors
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