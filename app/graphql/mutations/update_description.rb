# frozen_string_literal: true

module Mutations
  class UpdateDescription < Mutations::BaseMutation
    graphql_name "UpdateDescription"

    argument :id, ID, required: true
    argument :name, String, required: false


    field :description, Types::DescriptionType, null: false

    def resolve(id:, **args)
      description = Description.find(id)
      success = description.update_attributes(args.to_h)

      MutationResult.call(
        obj: { description: description },
        success: description.persisted?,
        errors: description.errors
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