# frozen_string_literal: true

module Mutations
  class DestroyResource < Mutations::BaseMutation
    graphql_name "DestroyResource"

    argument :id, ID, required: true

    field :resource, Types::ResourceType, null: false

    def resolve(id:)
      resource = Resource.find(id)
      success = resource.destroy
      
      MutationResult.call(
        obj: { resource: resource },
        success: success,
        errors: resource.errors
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