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
          if policy.user_reviewer_id.present? && (policy.user_reviewer_id != current_user.id)
            raise GraphQL::ExecutionError, "This Draft has been reviewed by another Admin."
          else
            policy_draft.publish!
            policy.update(status: "release")
            policy.update(user_reviewer_id: current_user.id)
          end
          admin_prep = User.with_role(:admin_preparer).pluck(:id)
          admin_rev = User.with_role(:admin_reviewer).pluck(:id)
          admin_main = User.with_role(:admin).pluck(:id)
          all_admin = admin_prep + admin_rev + admin_main
          admin = all_admin.uniq
          if policy.references.present?
            ref= policy&.references
            polisi = Policy.find(args[:id])
            ref.each do |r|
              namu = r&.policies&.pluck(:title).reject{ |k| k==polisi.title}
              nama = namu.join(", ")
              Notification.send_notification_to_all(admin ,"#{polisi.title} with #{r.name} has been updated. Consider review other related policies with #{r.name} #{nama}.","Policy with the same reference",policy, current_user&.id, "same_reference" ) 
              #{polisi.title} with #{r.name} has been updated. Consider review other related policies with #{r.name} #{nama}. 
            end
          end
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