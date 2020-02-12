module Resolvers
  module QueryType
    class BookmarksResolver < Resolvers::BaseResolver
      type Types::BookmarkType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil, limit: nil)
        current_user = context[:current_user]
        Bookmark.page(page).per(limit)
        @q = Bookmark.where(user_id: current_user.id).ransack(filter.as_json)
        @q.result.page(page).per(limit)
      end
    end
  end
end
