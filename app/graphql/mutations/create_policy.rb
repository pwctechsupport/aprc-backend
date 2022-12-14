module Mutations
  class CreatePolicy < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :title, String, required: true
    argument :description, String, required: true
    argument :policy_category_id, ID, required: true 
    argument :resource_id, ID, required: false
    argument :it_system_ids, [ID], required: false
    argument :resource_ids, [ID], required: false
    argument :status, String, required: false
    argument :business_process_ids, [ID], required: false
    argument :control_ids, [ID], required: false
    argument :risk_ids, [ID], required: false
    argument :created_by, String, required: false
    argument :last_updated_by, String, required: false
    argument :is_submitted, Boolean, required: false

    # return type from the mutation
    field :policy, Types::PolicyType, null: true

    def resolve(args)
      current_user = context[:current_user]
      args[:created_by] = current_user.name
      args[:last_updated_by] = current_user.name
      policy = current_user.policies.new(args.to_h)
      policy.save_draft

      admin = User.with_role(:admin_reviewer).pluck(:id)
      if policy.id.present?
        policy.update(created_by: policy&.user&.name)
        if args[:is_submitted].present?
          Notification.send_notification(admin, policy&.title, policy&.title, policy, current_user&.id, "request_draft")
        end
      else
        raise GraphQL::ExecutionError, "The exact same draft cannot be duplicated"
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