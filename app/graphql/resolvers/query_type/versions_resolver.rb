module Resolvers
  module QueryType
    class VersionsResolver < Resolvers::BaseResolver
      type Types::VersionType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:nil, page:nil, limit:nil)
        PaperTrail::Version.page(page).per(limit)
        @q = PaperTrail::Version.ransack(filter.as_json)
        @q.result.page(page).per(limit)
      end
    end
  end
end