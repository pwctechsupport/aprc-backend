# frozen_string_literal: true

module Mutations
  class DestroyManualAttachment < Mutations::BaseMutation
    graphql_name "DestroyManualAttachment"

    argument :id, ID, required: true

    field :manual, Types::ManualType, null: false

    def resolve(id:)
      current_user = context[:current_user]
      manual = Manual.find(id)
      if current_user.has_role?(:admin_reviewer)
        success = manual.update(resupload:nil)
      else
        raise GraphQL::ExecutionError ,"Only User with role \"Admin Reviewer\" can Upload the user manual"
      end
      
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