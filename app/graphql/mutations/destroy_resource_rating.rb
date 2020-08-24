#frozen_string_literal: true

module Mutations
  class DestroyResourceRating < Mutations::BaseMutation
    graphql_name "DestroyResourceRating"
    argument :id, ID, required: true

    field :resource_rating, Types::ResourceRatingType, null: true

    def resolve(id:)
      resource_rating = ResourceRating.find(id)
      success = resource_rating.destroy

      MutationResult.call(
        obj: {resource_rating: resource_rating},
        success: success,
        errors: resource_rating.errors
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
