module Resolvers
  module QueryType
    class BookmarkRisksResolver < Resolvers::BaseResolver
      type Types::BookmarkRiskType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil, limit: nil)
        BookmarkRisk.page(page).per(limit)
        @q = BookmarkRisk.ransack(filter.as_json)
        @q.result.page(page).per(limit)
      end
    end
  end
end
