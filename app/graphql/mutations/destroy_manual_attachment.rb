# frozen_string_literal: true

module Mutations
  class DestroyManualAttachment < Mutations::BaseMutation
    graphql_name "DestroyManualAttachment"

    argument :id, ID, required: true

    field :manual, Types::ManualType, null: false

    def resolve(id:)
      manual = Manual.find(id)
      success = manual.update(resupload:nil)
      
      MutationResult.call(
        obj: { manual: manual },
        success: success,
        errors: manual.errors
      )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end

    # def ready?(args)
    #   authorize_user
    # end
  end
end