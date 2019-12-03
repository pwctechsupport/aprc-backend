# frozen_string_literal: true

module Mutations
  class DestroyReference < Mutations::BaseMutation
    graphql_name "DestroyReference"

    argument :id, ID, required: true

    field :reference, Types::ReferenceType, null: false

    def resolve(id:)
      reference = Reference.find(id)
      success = reference.destroy
      
      MutationResult.call(
        obj: { reference: reference },
        success: success,
        errors: reference.errors
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