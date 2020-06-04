module Mutations
  class CreateRole < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: false

    # return type from the mutation
    field :role, Types::RoleType, null: true

    def resolve(args)
      role = Role.create!(args.to_h)
      
      MutationResult.call(
          obj: { role: role },
          success: role.persisted?,
          errors: role.errors
        )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end
  end
end