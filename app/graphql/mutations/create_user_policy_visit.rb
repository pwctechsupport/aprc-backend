module Mutations
  class CreateUserPolicyVisit < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :policy_id, ID, required: true
    argument :recent_visit, String, required: false
    argument :user_id, ID, required: false



    # return type from the mutation
    field :user_policy_visit, Types::UserPolicyVisitType, null: true

    def resolve(args)
      current_user = context[:current_user]
      args[:user_id] = current_user.id
      args[:recent_visit] = Time.now
      user_policy_visit = current_user.policy_visits.where("policy_id = ?", args[:policy_id])
      if user_policy_visit.present?
        user_policy_visit = user_policy_visit&.first
        user_policy_visit&.update_attributes(recent_visit: args[:recent_visit])
      else
        user_policy_visit = UserPolicyVisit.create!(args.to_h)
      end

      MutationResult.call(
          obj: { user_policy_visit: user_policy_visit },
          success: user_policy_visit.persisted?,
          errors: user_policy_visit.errors
        )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end
  end
end