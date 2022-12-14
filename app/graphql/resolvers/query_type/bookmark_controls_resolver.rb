module Resolvers
  module QueryType
    class BookmarkControlsResolver < Resolvers::BaseResolver
      type Types::BookmarkControlType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil, limit: nil)
        BookmarkControl.page(page).per(limit)
        @q = BookmarkControl.ransack(filter.as_json)
        @q.result.page(page).per(limit)
      end
    end
  end
end
