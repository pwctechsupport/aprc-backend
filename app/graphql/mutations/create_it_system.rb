module Mutations
  class CreateItSystem < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true


    # return type from the mutation
    field :ItSystem, Types::ItSystemType, null: true

    def resolve(name: nil)
      it_system = ItSystem.create!(
        name: name
      )
      MutationResult.call(
          obj: { it_system: it_system },
          success: it_system.persisted?,
          errors: it_system.errors
        )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end
  end
end