module Resolvers
  module QueryType
    class ResourceRatingsResolver < Resolvers::BaseResolver
      type Types::ResourceRatingType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil, limit: nil)
        ResourceRating.page(page).per(limit)
        @q = ResourceRating.ransack(filter.as_json)
        @q.result.page(page).per(limit)
      end
    end
  end
end
