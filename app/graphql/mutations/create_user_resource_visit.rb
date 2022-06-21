module Mutations
  class CreateUserResourceVisit < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :resource_id, ID, required: true
    argument :recent_visit, String, required: false
    argument :user_id, ID, required: false


    # return type from the mutation
    field :user_resource_visit, Types::UserResourceVisitType, null: true

    def resolve(args)
      current_user = context[:current_user]
      args[:user_id] = current_user.id
      args[:recent_visit] = Time.now
      user_resource_visit = current_user.resource_visits.where("resource_id = ?", args[:resource_id])
      if user_resource_visit.present?
        user_resource_visit = user_resource_visit&.first
        user_resource_visit&.update!(recent_visit: args[:recent_visit])
      else
        user_resource_visit = UserResourceVisit.create!(args.to_h)
      end

      MutationResult.call(
          obj: { user_resource_visit: user_resource_visit },
          success: user_resource_visit.persisted?,
          errors: user_resource_visit.errors
        )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end
  end
end