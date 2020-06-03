module Mutations
  class UpdateUserPassword < Mutations::BaseMutation
    graphql_name "UpdateCurrentUserPassword"
    argument :old_password, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true

    field :user, String, null: false

    def resolve(args)
      current_user = context[:current_user]
      if current_user&.valid_password?(args[:old_password])
        user = current_user.update_attributes!(args)
        message = "Your Password Changed Successfully"
        errori = "Password confirmation mismatch"
      else
        raise GraphQL::ExecutionError, "Old password confirmation mismatch"
      end

      MutationResult.call(
        obj: { user: message },
        success: message,
        errors: errori
      )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end
  end
end