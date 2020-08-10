module Mutations
  class CreateRequestEdit < Mutations::BaseMutation
    argument :originator_id, ID, required: true
    argument :originator_type, String, required: true
    argument :user_id, ID, required: false

    field :request_edit, Types::RequestEditType, null: true

    def resolve(args)
      current_user = context[:current_user]
      args[:user_id] = current_user.id
      case args[:originator_type]
      when "Policy"
        policy = Policy.find(args[:originator_id])
        if policy.request_edit.present? && policy.request_edit.requested?
          raise GraphQL::ExecutionError, "Request not permitted. Another Request exist"
        else
          request_edit = RequestEdit.create!(args.to_h)
          policy.update(status: "waiting_for_approval")
          admin = User.with_role(:admin_reviewer).pluck(:id)
          Notification.send_notification(admin, policy.title, "Request Edit Policy", policy, current_user.id, "request_edit")
        end
      when "User"
        user = User.find(args[:originator_id])
        if user.request_edit.present? && user.request_edit.requested?
          raise GraphQL::ExecutionError, "Request not permitted. Another Request exist"
        else
          request_edit = RequestEdit.create!(args.to_h)
          user.update(status: "waiting_for_approval")
          admin = User.with_role(:admin_reviewer).pluck(:id)
          Notification.send_notification(admin, user.name, "Request Edit User", user, current_user.id, "request_edit")
        end
      when "Risk"
        risk = Risk.find(args[:originator_id])
        if risk.request_edit.present? && risk.request_edit.requested?
          raise GraphQL::ExecutionError, "Request not permitted. Another Request exist"
        else
          request_edit = RequestEdit.create!(args.to_h)
          risk.update(status: "waiting_for_approval")
          admin = User.with_role(:admin_reviewer).pluck(:id)
          Notification.send_notification(admin, risk.name, "Request Edit Risk", risk, current_user.id, "request_edit")
        end
      when "Control"
        control = Control.find(args[:originator_id])
        if control.request_edit.present? && control.request_edit.requested?
          raise GraphQL::ExecutionError, "Request not permitted. Another Request exist"
        else
          request_edit = RequestEdit.create!(args.to_h)
          control.update(status: "waiting_for_approval")
          admin = User.with_role(:admin_reviewer).pluck(:id)
          Notification.send_notification(admin, control.description, "Request Edit Control", control, current_user.id, "request_edit")
        end
      when "PolicyCategory"
        policy_category = PolicyCategory.find(args[:originator_id])
        if policy_category.request_edit.present? && policy_category.request_edit.requested?
          raise GraphQL::ExecutionError, "Request not permitted. Another Request exist"
        else
          request_edit = RequestEdit.create!(args.to_h)
          policy_category.update(status: "waiting_for_approval")
          admin = User.with_role(:admin_reviewer).pluck(:id)
          Notification.send_notification(admin, policy_category.name, "Request Edit Policy Category", policy_category, current_user.id, "request_edit")
        end
      when "Resource"
        resource = Resource.find(args[:originator_id])
        if resource.request_edit.present? && resource.request_edit.requested?
          raise GraphQL::ExecutionError, "Request not permitted. Another Request exist"
        else
          request_edit = RequestEdit.create!(args.to_h)
          resource.update(status: "waiting_for_approval")
          admin = User.with_role(:admin_reviewer).pluck(:id)
          Notification.send_notification(admin, resource.name, "Request Edit Resource", resource, current_user.id, "request_edit")
        end
      end
      # request_edit = current_user.request_edit_risks.create!(args.to_h)
      MutationResult.call(
        obj: {request_edit: request_edit},
        success: request_edit.persisted?,
        errors: request_edit.errors
      )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end

    def ready?(args)
      authorize_user
    end

  end
end