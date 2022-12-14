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
      if policy.is_submitted
        if current_user.present? && current_user.has_role?(:admin_reviewer)
          policy_draft = policy.draft
          

          if args[:publish] === true
            %w(business_processes risks controls references resources).each do |relation|
              if policy&.send("policy_#{relation}").where.not(draft_id: nil).present?
                if policy&.send("policy_#{relation}").where(draft_id: nil).present?
                  policy&.send("policy_#{relation}").where(draft_id: nil).destroy_all 
                end
                policy&.send("policy_#{relation}").where.not(draft_id: nil).each {|x| x.draft.publish!}
              end
            end

            policy_draft.publish!
            policy.update_attributes(status: "release", user_reviewer_id: current_user.id, true_version: (policy&.true_version + 1.0))
            admin_prep = [policy.last_updated_by_user_id] || User.with_role(:admin_preparer).pluck(:id)
            admin_rev = User.with_role(:admin_reviewer).pluck(:id)
            admin_main = User.with_role(:admin).pluck(:id)
            all_admin = admin_prep + admin_rev + admin_main
            admin = all_admin.uniq
            policy.update_attributes(is_submitted:false, is_related: false)
            if policy.references.present?
              ref= policy&.references
              polisi = Policy.find(args[:id])
              ref.each do |r|
                namu = r&.policies&.pluck(:id).reject{ |k| k==polisi.id}
                nama = namu.join(", ")
                name = namu.map{|x| Policy.find(x)&.title}
                nami = name.join(", ")
                if r.policies.count > 1 # don't send notif if reference just have 1 policy
                  Notification.send_notification_to_all(admin ,"#{polisi.title} with #{r.name} has been updated. Consider review for other related policies with #{r.name} i.e.: #{nami}","#{nama}",policy, current_user&.id, "related_reference" ) 
                end
                #{polisi.title} with #{r.name} has been updated. Consider review other related policies with #{r.name} #{nama}. 
              end
            end
            Notification.send_notification(admin_prep, "Policy Draft titled #{policy.title} Approved", policy&.title,policy, current_user&.id, "request_draft_approved")
            if policy&.present? && policy&.request_edit&.present?
              policy&.request_edit&.destroy
            end
          else
            admin_prep = [policy.last_updated_by_user_id] || User.with_role(:admin_preparer).pluck(:id)
            Notification.send_notification(admin_prep, "Policy Draft titled #{policy.title} Has been Rejected", policy&.title,policy, current_user&.id, "request_draft_rejected")
            if policy.published_at.nil?
              policy_draft.update_attributes(
                object_changes: JSON.parse(policy_draft.object_changes).update({"status" => [nil, "draft"]}).to_json, 
                object:JSON.parse(policy_draft.object).update({"status" => "draft"}).to_json
              )
              policy.update(status:"draft", is_submitted: false)
            else
              policy_draft.revert!
              if policy&.present?
                policy.update_attributes(is_submitted:false, is_related: false, status: "release")
              end
              %w(business_processes risks controls references resources).each do |relation|
                if policy&.send("policy_#{relation}").where.not(draft_id: nil).present?
                  policy&.send("policy_#{relation}").where.not(draft_id: nil).destroy_all 
                end
              end
            end
            if policy&.present? && policy&.request_edit&.present?
              policy&.request_edit&.destroy
            end              
          end 
        else
          raise GraphQL::ExecutionError, "User is not an Admin."
        end
      else
        raise GraphQL::ExecutionError, "This Draft has not been Submitted."
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


# policy.draft.object_was == policy.draft.object
# JSON.parse(policy.draft.object_changes).keys
# policy.draft.changeset[policy.draft.changeset.keys.first].count