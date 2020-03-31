module Mutations
  class UpdateDraftPolicy < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :id, ID, required: true
    argument :title, String, required: false
    argument :description, String, required: false
    argument :policy_category_id, ID, required: false 
    argument :resource_id, ID, required: false
    argument :it_system_ids, [ID], required: false
    argument :resource_ids, [ID], required: false
    argument :status, Types::Enums::Status, required: false
    argument :business_process_ids, [ID], required: false
    argument :control_ids, [ID], required: false
    argument :risk_ids, [ID], required: false

    # return type from the mutation
    field :policy, Types::PolicyType, null: true

    def resolve(id:, **args)
      current_user = context[:current_user]
      policy = Policy.find(id)
      if policy.user_id == current_user&.id
        policy.draft.reify.update_attributes(args.stringify_keys!)
        policy.draft.update(object_changes: JSON.parse(policy.draft.object_changes).update(args.stringify_keys!).to_json)
        policy.draft.update(object:JSON.parse(policy.draft.object).update(args.stringify_keys!).to_json)

      else
        raise GraphQL::ExecutionError, "You cannot edit this draft. This Draft belongs to another User"
      end

      # policy = Policy.create!(args.to_h)
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
