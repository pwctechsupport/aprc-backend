module Mutations
  class CreateUser < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :email, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true
    argument :phone, String, required: true

    # return type from the mutation
    field :user, Types::UserType, null: true

    def resolve(email: nil, password: nil, password_confirmation: nil, phone: nil)
      user = User.create!(
        email: email,
        password: password,
        password_confirmation: password_confirmation,
        phone: phone,
 
      )
      {user: user}
      MutationResult.call(
          obj: { user: user },
          success: user.persisted?,
          errors: user.errors
        )

    end

  end
end