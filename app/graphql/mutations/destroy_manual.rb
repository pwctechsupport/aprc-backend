#frozen_string_literal: true

module Mutations
  class DestroyManual < Mutations::BaseMutation
    graphql_name "DestroyManual"
    argument :id, [ID], required: true

    field :manual, Boolean, null: false

    def resolve(id:)
      manual = Manual.find_by(id: id)
      success = manual.destroy

      MutationResult.call(
        obj: {manual: manual},
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
