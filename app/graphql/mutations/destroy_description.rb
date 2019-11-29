# frozen_string_literal: true

module Mutations
  class DestroyDescription < Mutations::BaseMutation
    graphql_name "DestroyDescription"

    argument :id, ID, required: true

    field :description, Types::DescriptionType, null: false

    def resolve(id:)
      description = Description.find(id)
      success = description.destroy
      
      MutationResult.call(
        obj: { description: description },
        success: success,
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