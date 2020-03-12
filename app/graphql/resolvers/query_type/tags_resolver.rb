module Resolvers
  module QueryType
    class TagsResolver < Resolvers::BaseResolver
      type Types::TagType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil, limit: nil)
        current_user = context[:current_user]
        @q = Tag.ransack(filter.as_json)
        @q.result.page(page).per(limit)
      end
    end
  end
end
