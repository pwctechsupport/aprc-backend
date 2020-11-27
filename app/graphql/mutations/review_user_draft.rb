module Mutations
  class ReviewUserDraft < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :publish, Boolean, required: true
    argument :id, ID, required: true
    
    # return type from the mutation
    field :user, Types::UserType, null: true

    def resolve(args)
      current_user = context[:current_user]
      user = User.find(args[:id])

      if current_user.present? && current_user.has_role?(:admin_reviewer)
        user_draft= user.draft
        admin_prep = User.with_role(:admin_preparer).pluck(:id)
        if args[:publish] === true
          if user_draft&.event == "update"
            serial = ["policy_category", "main_role"]
            serial.each do |sif|
              if user_draft&.changeset[sif].present?
                user_draft&.changeset[sif].map!{|x| JSON.parse(x)}
              end
            end
          end
          user_draft&.reify
          user_draft&.publish!
          user.update(user_reviewer_id: current_user.id, status: "release")
          Notification.send_notification(admin_prep, "User Draft named #{user&.name} Approved", user&.name,user, current_user&.id, "request_draft_approved")
          if user&.present? && user&.request_edit&.present?
            user&.request_edit&.destroy
          end
        else
          Notification.send_notification(admin_prep, "User Draft named #{user&.name} Rejected", user&.name,user, current_user&.id, "request_draft_rejected")
          policy_category_rejected = user&.policy_category
          user_draft.revert!
          if user&.present? && user&.request_edit&.present?
            user&.request_edit&.destroy
            user.update(policy_category: policy_category_rejected, status: "release")
          end
        end 
      else
        raise GraphQL::ExecutionError, "User is not an Admin."
      end

      # user = user.create!(args.to_h)
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