# frozen_string_literal: true

module Mutations
  class UpdateReference < Mutations::BaseMutation
    graphql_name "UpdateReference"

    argument :id, ID, required: true
    argument :name, String, required: false


    field :reference, Types::ReferenceType, null: false

    def resolve(id:, **args)
      reference = Reference.find(id)
      success = reference.update_attributes(args.to_h)

      MutationResult.call(
        obj: { reference: reference },
        success: reference.persisted?,
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