module Mutations
  class CreateUser < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :role_ids, [ID], required: false
    argument :policy_category_ids, [ID], required: false
    argument :email, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true
    argument :name, String, required: false
    argument :phone, String, required: false
    argument :status, Types::Enums::Status, required: false
    argument :department_id, ID, required: false

    # return type from the mutation
    field :user, Types::UserType, null: true

    def resolve(args)
      user = User.create(args.to_h)
      current_user = context[:current_user]
      admin = User.with_role(:admin_reviewer).pluck(:id)
      if user.id.present?
        Notification.send_notification(admin,user.email,"",user, current_user&.id, "request_draft")
      else
        raise GraphQL::ExecutionError, "The exact same draft cannot be duplicated"
      end

      MutationResult.call(
        obj: { user: user },
        success: user.persisted?,
        errors: user.errors.full_messages
      )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end
  end
end