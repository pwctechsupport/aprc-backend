module Mutations
  class ForgotPassword < Mutations::BaseMutation
    graphql_name "ForgotPassword"

    argument :email, String, required: false

    field :user, String, null: false

    def resolve(email:)
      user = User.find_by(email: email)
      if user.present?
        user.send_reset_password_instructions
        message = "You will receive an email with instructions on how to reset your password in a few minutes."
      else
        message = "email did not found!"
      end

      MutationResult.call(
        obj: { user: message },
        success: user.present?,
        errors: [message]
      )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end
  end
end
