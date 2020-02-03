module Mutations
  class UpdatePassword < Mutations::BaseMutation
    graphql_name "UpdatePassword"

    argument :password, String, required: false
    argument :password_confirmation, String, required: false
    argument :reset_password_token, String, required: false

    field :user, String, null: false

    def resolve(args)
      user = User.reset_password_by_token(args)
      message = "Successfully reset password."

      MutationResult.call(
        obj: { user: message },
        success: !user.errors.present?,
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
