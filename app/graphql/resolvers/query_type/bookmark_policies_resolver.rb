module Resolvers
  module QueryType
    class BookmarkPoliciesResolver < Resolvers::BaseResolver
      type Types::BookmarkPolicyType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil, limit: nil)
        BookmarkPolicy.page(page).per(limit)
        @q = BookmarkPolicy.ransack(filter.as_json)
        @q.result.page(page).per(limit)
      end
    end
  end
end
