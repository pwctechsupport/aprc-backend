module Resolvers
  module QueryType
    class BookmarksResolver < Resolvers::BaseResolver
      type Types::BookmarkType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil, limit: nil)
        current_user = context[:current_user]
        @q = Bookmark.where(user_id: current_user&.id).ransack(filter.as_json)
        @q.sorts = 'created_at desc' if @q.sorts.empty?
        @q.result.page(page).per(limit)
      end
      
      def ready?(args)
        authorize_user
      end
    end
  end
end
