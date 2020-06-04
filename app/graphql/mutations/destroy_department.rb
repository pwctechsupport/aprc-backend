# frozen_string_literal: true

module Mutations
  class DestroyDepartment < Mutations::BaseMutation
    graphql_name "DestroyDepartment"

    argument :id, ID, required: true

    field :department, Types::DepartmentType, null: false

    def resolve(id:)
      department = Department.find(id)
      success = department.destroy
      
      MutationResult.call(
        obj: { department: department },
        success: success,
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