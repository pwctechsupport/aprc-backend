module Mutations
  class CreateDepartment < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: false


    # return type from the mutation
    field :department, Types::DepartmentType, null: true

    def resolve(args)
      department = Department.create!(args.to_h)
      
      MutationResult.call(
          obj: { department: department },
          success: department.persisted?,
          errors: department.errors
        )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end
  end
end