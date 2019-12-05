module Mutations
  class CreateBusinessProcess < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true


    # return type from the mutation
    field :business_process, Types::BusinessProcessType, null: true

    def resolve(name: nil)
      business_process = BusinessProcess.create!(
        name: name
      )

      MutationResult.call(
          obj: { business_process: business_process },
          success: business_process.persisted?,
          errors: business_process.errors
        )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end
  end
end