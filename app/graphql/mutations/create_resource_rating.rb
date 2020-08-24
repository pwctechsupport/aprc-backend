#frozen_string_literal: true

module Mutations
  class CreateResourceRating < Mutations::BaseMutation
    argument :resource_id, ID, required: true
    argument :rating, Float, required: true

    field :resource_rating, Types::ResourceRatingType, null: true

    def resolve(args)
      current_user = context[:current_user]
      resource_rating = current_user.resource_ratings.where(user_id: current_user.id, resource_id: args[:resource_id]).first
      if resource_rating
        resource_rating.update_attributes(args.to_h)
      else
        resource_rating = current_user.resource_ratings.create!(args.to_h)
      end 

      MutationResult.call(
        obj: {resource_rating: resource_rating},
        success: resource_rating.persisted?,
        errors: resource_rating.errors
      )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end

    def ready?(args)
      authorize_user
    end

  end
end
