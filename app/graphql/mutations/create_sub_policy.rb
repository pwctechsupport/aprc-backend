module Mutations
  class CreateSubPolicy < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :title, String, required: true
    argument :description, String, required: true
    argument :parent_id, ID, required: true
    argument :reference_ids, [ID], required: false
    argument :status, Types::Enums::Status, required: false
    argument :business_process_ids, [ID], required: false
    argument :control_ids, [ID], required: false
    argument :risk_ids, [ID], required: false
    argument :resource_ids, [ID], required: false
    argument :created_by, String, required: false
    argument :last_updated_by, String, required: false



    # return type from the mutation
    field :policy, Types::PolicyType, null: true

    def resolve(args)
      current_user = context[:current_user]
      args[:created_by] = current_user&.name || "User with ID#{current_user&.id}"
      args[:last_updated_by] = current_user&.name || "User with ID#{current_user&.id}"
      policy = current_user.policies.new(args.to_h)
      policy.save_draft

      admin = User.with_role(:admin_reviewer).pluck(:id)
      if policy.id.present?
        policy.update(created_by: policy&.user&.name)
        Notification.send_notification(admin, policy&.title, policy&.title, policy, current_user&.id, "request_draft")
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
  end
end