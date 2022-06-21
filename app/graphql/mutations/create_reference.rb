module Mutations
  class CreateReference < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true
    argument :status, Types::Enums::Status, required: false
    argument :policy_ids, [ID], required: false
    argument :created_by, String, required: false
    argument :last_updated_by, String, required: false
    



    # return type from the mutation
    field :reference, Types::ReferenceType, null: true

    def resolve(name: nil, status: nil, policy_ids: nil, created_by: nil, last_updated_by: nil)
      current_user = context[:current_user]
      reference = Reference.create!(
        name: '#' << name,
        status: status,
        policy_ids: policy_ids,
        created_by: current_user&.name || "User with ID#{current_user&.id}",
        last_updated_by: current_user&.name || "User with ID#{current_user&.id}"
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