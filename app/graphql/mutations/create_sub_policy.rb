module Mutations
  class CreateSubPolicy < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :title, String, required: true
    argument :description, String, required: true
    argument :parent_id, ID, required: true
    argument :reference_ids, [ID], required: false


    # return type from the mutation
    field :policy, Types::PolicyType, null: true

    def resolve(parent_id:, title: nil, description: nil, reference_ids: nil)
      policy = Policy.create!(
        title: title,
        description: description,
        parent: Policy.find(parent_id),
        user_id: context[:current_user].id,
        reference_ids: reference_ids
      )
      MutationResult.call(
          obj: { policy: policy },
          success: policy.persisted?,
          errors: policy.errors
        )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end
  end
end