# frozen_string_literal: true

module Mutations
  class UpdateDepartment < Mutations::BaseMutation
    graphql_name "UpdateDepartment"

    argument :id, ID, required: true
    argument :name, String, required: false
    


    field :department, Types::DepartmentType, null: false

    def resolve(id:, **args)
      current_user = context[:current_user]
      department = Department.find(id)
      department.update(args.to_h)

      
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

    def ready?(args)
      authorize_user
    end
  end
end