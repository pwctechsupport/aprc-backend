module Mutations
  class CreatePolicy < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :title, String, required: true
    argument :description, String, required: true
    argument :policy_category_id, ID, required: false 
    argument :it_system_ids, [ID], required: false
    argument :resource_ids, [ID], required: false
    argument :business_process_ids, [ID], required: false

    # return type from the mutation
    field :policy, Types::PolicyType, null: true

    def resolve(title: nil, description: nil, policy_category_id: nil, user_id: nil, it_system_ids: nil, resource_ids: nil, business_process_ids: nil)
      policy = Policy.create!(title: title,description: description,
      policy_category_id: policy_category_id,
      user_id: context[:current_user].id,
      it_system_ids: it_system_ids,
      resource_ids: resource_ids,
      business_process_ids: business_process_ids
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
    def ready?(args)
      authorize_user
    end
  end
end