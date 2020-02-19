module Mutations
  class CreateRequestEdit < Mutations::BaseMutation
    argument :originator_id, ID, required: true
    argument :originator_type, String, required: true

    field :request_edit, Types::RequestEditType, null: true

    def resolve(args)
      current_user = context[:current_user]
      args[:user_id] = current_user&.id
      case args[:originator_type]
      when "Policy"
        policy = Policy.find(args[:originator_id])
        if policy.request_edit.present? && policy.request_edit.last.requested?
          raise GraphQL::ExecutionError, "Request not permitted. Another Request exist"
        else
          request_edit = RequestEdit.create!(args.to_h)
          admin = User.with_role(:admin_reviewer).pluck(:id)
          Notification.send_notification(admin, policy.title, "Request Edit Policy", policy, current_user.id)
        end
      when "User"
        user = User.find(args[:originator_id])
        if user.request_edit.present? && user.request_edit.last.requested?
          raise GraphQL::ExecutionError, "Request not permitted. Another Request exist"
        else
          request_edit = RequestEdit.create!(args.to_h)
          admin = User.with_role(:admin_reviewer).pluck(:id)
          Notification.send_notification(admin, user.name, "Request Edit User", user, current_user.id)
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