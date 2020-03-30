module Mutations
  class SubmitDraftPolicy < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :id, ID, required: true

    # return type from the mutation
    field :policy, Types::PolicyType, null: true

    def resolve(id:, **args)
      current_user = context[:current_user]
      policy = Policy.find(id)
      if policy.user_id == current_user&.id
        args[:is_submitted] = true
        policy.update(args.to_h)
      else
        raise GraphQL::ExecutionError, "You cannot submit this draft. This Draft belongs to another User"
      end
      

      admin = User.with_role(:admin_reviewer).pluck(:id)
      if policy.id.present?
        Notification.send_notification(admin, policy.title, policy.description, policy, current_user.id, "request_draft")
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