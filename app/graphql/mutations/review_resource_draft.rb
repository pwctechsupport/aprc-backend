module Mutations
  class ReviewResourceDraft < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :publish, Boolean, required: true
    argument :id, ID, required: true
    
    # return type from the mutation
    field :resource, Types::ResourceType, null: true

    def resolve(args)
      current_user = context[:current_user]
      resource = Resource.find(args[:id])

      if current_user.present? && current_user.has_role?(:admin_reviewer)
        resource_draft = resource.draft
        rodi_res = resource.resupload
        rodi_name = resource.resupload_file_name
        admin_prep = [resource.last_updated_by_user_id] || User.without_role(:admin_reviewer).pluck(:id)
        if args[:publish] === true
          if resource&.resource_controls.where.not(draft_id: nil).present?
            if resource&.resource_controls.where(draft_id: nil).present?
              resource&.resource_controls.where(draft_id: nil).destroy_all
            end
            resource&.resource_controls.where.not(draft_id: nil).each {|x| x.draft.publish!}
          end
          if resource&.policy_resources.where.not(draft_id: nil).present?
            if resource&.policy_resources.where(draft_id: nil).present?
              resource&.policy_resources.where(draft_id: nil).destroy_all
            end
            resource&.policy_resources.where.not(draft_id: nil).each {|x| x.draft.publish!}
          end

          resource_draft.publish!

          resource.update_attributes(user_reviewer_id: current_user.id, status: "release", is_related: false)
          Notification.send_notification(admin_prep, "Resource Draft named #{resource&.name} Approved", resource&.name,resource, current_user&.id, "request_draft_approved")

          if resource.resupload.present?
            resource.update_attributes!(resupload:rodi_res, resupload_file_name:rodi_name)
          end
          if resource&.present? && resource&.request_edit&.present?
            resource&.request_edit&.destroy
          end
        else
          Notification.send_notification(admin_prep, "Resource Draft named #{resource&.name} Rejected", resource&.name,resource, current_user&.id, "request_draft_rejected")
          resource_draft.revert!
          if resource&.resource_controls.where.not(draft_id: nil).present?
            resource&.resource_controls.where.not(draft_id: nil).destroy_all
          end
          if resource&.policy_resources.where.not(draft_id: nil).present?
            resource&.policy_resources.where.not(draft_id: nil).destroy_all
          end
          if resource&.present?
            resource.update(is_related: false, status: "release")
          end
          if resource&.present? && resource&.request_edit&.present?
            resource&.request_edit&.destroy
          end
        end 
      else
        raise GraphQL::ExecutionError, "User is not an Admin."
      end

      

      # resource = resource.create!(args.to_h)
      MutationResult.call(
          obj: { resource: resource },
          success: resource.persisted?,
          errors: resource.errors
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