module Mutations
  class ApproveRequestEdit < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :approve, Boolean, required: true

    field :request_edit, Types::RequestEditType, null: true

    def resolve(id:, **args)
      current_user = context[:current_user]
      request_edit = RequestEdit.find(id)
      admin_prep = User.with_role(:admin_preparer).pluck(:id)
      if request_edit.requested? && args[:approve]
        request_edit.approve!
        request_edit.update(approver_id: current_user&.id)
        Notification.send_notification(admin_prep, request_edit&.to_name, "Request Edit Has been Approved By #{current_user&.name}",request_edit&.originator, current_user&.id, "request_edit_approved")
      else
        request_edit.reject!
        request_edit.update(approver_id: current_user&.id)
        Notification.send_notification(admin_prep, request_edit&.to_name, "Request Edit Has been Rejected By #{current_user&.name}",request_edit&.originator, current_user&.id, "request_edit_rejected")
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