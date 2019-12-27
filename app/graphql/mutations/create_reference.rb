module Mutations
  class CreateReference < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true
    argument :status, Types::Enums::Status, required: false



    # return type from the mutation
    field :reference, Types::ReferenceType, null: true

    def resolve(name: nil, status: nil)
      reference = Reference.create!(
        name: '#' << name,
        status: status
      )
      MutationResult.call(
          obj: { reference: reference },
          success: reference.persisted?,
          errors: reference.errors
        )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end
  end
end