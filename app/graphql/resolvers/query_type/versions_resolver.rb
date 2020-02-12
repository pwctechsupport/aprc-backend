module Resolvers
  module QueryType
    class VersionsResolver < Resolvers::BaseResolver
      type Types::VersionType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:nil, page:nil, limit:nil)
        current_user = context[:current_user]
        PaperTrail::Version.page(page).per(limit)
        @q = PaperTrail::Version.where(whodunnit: current_user.id).ransack(filter.as_json)
        @q.result.page(page).per(limit)
      end
    end
  end
end