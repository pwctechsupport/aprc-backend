module Resolvers
  module QueryType
    class BookmarksResolver < Resolvers::BaseResolver
      type Types::BookmarkType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil, limit: nil)
        Bookmark.page(page).per(limit)
        @q = Bookmark.ransack(filter.as_json)
        @q.result.page(page).per(limit)
      end
    end
  end
end
