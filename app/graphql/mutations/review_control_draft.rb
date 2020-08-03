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
          else
            if control&.control_business_processes.where.not(draft_id: nil).present?
              if control&.control_business_processes.where(draft_id: nil).present?
                control&.control_business_processes.where(draft_id: nil).destroy_all
              end
              control&.control_business_processes.where.not(draft_id: nil).each {|x| x.draft.publish!}
            end

            if control&.control_risks.where.not(draft_id: nil).present?
              if control&.control_risks.where(draft_id: nil).present?
                control&.control_risks.where(draft_id: nil).destroy_all
              end
              control&.control_risks.where.not(draft_id: nil).each {|x| x.draft.publish!}
            end

            if control_draft.event == "update"
              serial = ["control_owner", "assertion", "ipo"]
              serial.each do |sif|
                if control_draft.changeset[sif].present?
                  control_draft.changeset[sif].map!{|x| JSON.parse(x)}
                end
              end
            end
            control_draft.reify
            control_draft.publish!
            if control.activity_controls.where.not(draft_id: nil).present?
              control&.activity_controls.where.not(draft_id: nil).each{|x| x.draft.publish!}
            end

            control.update_attributes(user_reviewer_id: current_user.id, is_related: false)
            control.update(status: "release")
            Notification.send_notification(admin_prep, "Control Draft with owner #{control&.control_owner.join(", ")} Approved", control&.description,control, current_user&.id, "request_draft_approved")
          end
          if control&.present? && control&.request_edit&.present?
            control&.request_edit&.destroy
          end
        else
          if control.user_reviewer_id.present? && (control.user_reviewer_id != current_user.id)
            raise GraphQL::ExecutionError, "This Draft has been reviewed by another Admin."
          else
            Notification.send_notification(admin_prep, "Control Draft with owner #{control&.control_owner.join(", ")} Rejected", control&.description,control, current_user&.id, "request_draft_rejected")
            control_owner_rejected = control&.control_owner
            control_draft.revert!
            if control&.present?
              control.update(is_related:false)
              if control.activity_controls.where.not(draft_id: nil).present?
                control&.activity_controls.where.not(draft_id: nil).each{|x| x.draft.revert!}
              end
            end
            if control&.control_business_processes.where.not(draft_id: nil).present?
              control&.control_business_processes.where.not(draft_id: nil).destroy_all
            end
            if control&.control_risks.where.not(draft_id: nil).present?
              control&.control_risks.where.not(draft_id: nil).destroy_all
            end
            if control&.present? && control&.request_edit&.present?
              control&.request_edit&.destroy
              control.update(control_owner: control_owner_rejected, status: "release")
            end
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