#frozen_string_literal: true

module Mutations
  class UpdateResourceRating < Mutations::BaseMutation
    argument :resource_id, ID, required: true
    argument :rating, Float, required: true
    argument :user_id, ID, required: true

    field :resource_rating, Types::ResourceRatingType, null: true

    def resolve(resource_id:, **args)
      resource_rating = ResourceRating.find(id)
      byebug
      resource_rating.update_attributes(args.to_h)
      MutationResult.call(
        obj: {resource_rating: resource_rating},
        success: resource_rating.persisted?,
        errors: resource_rating.errors
      )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.now(
        "Invaild Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(',')}"
      )
    end
    # def ready?(args)
    #   authorize_user
    # end

  end
end
