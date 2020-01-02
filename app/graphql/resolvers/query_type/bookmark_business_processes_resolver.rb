module Resolvers
  module QueryType
    class BookmarkBusinessProcessesResolver < Resolvers::BaseResolver
      type Types::BookmarkBusinessProcessType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil, limit: nil)
        BookmarkBusinessProcess.page(page).per(limit)
        @q = BookmarkBusinessProcess.ransack(filter.as_json)
        @q.result.page(page).per(limit)
      end
    end
  end
end
