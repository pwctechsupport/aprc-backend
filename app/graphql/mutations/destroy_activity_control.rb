#frozen_string_literal: true

module Mutations
  class DestroyActivityControl < Mutations::BaseMutation
    graphql_name "DestroyActivityControl"
    argument :ids, [ID], required: true

    field :activity_control, Boolean, null: false

    def resolve(ids:)
      activity_control = ActivityControl.where(id: ids)
      success = activity_control.destroy_all

      MutationResult.call(
        obj: {activity_control: activity_control},
        success: success,
        errors: success
      )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(',')}"
      )
    end

    def ready?(args)
      authorize_user
    end

  end
end
