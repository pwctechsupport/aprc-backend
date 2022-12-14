module Resolvers
  module QueryType
    class EnumListsResolver < Resolvers::BaseResolver
      type Types::EnumListType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil, limit: nil)
        EnumList.page(page).per(limit)
        @q = EnumList.ransack(filter.as_json)
        @q.result.page(page).per(limit)
      end

      def ready?(args)
        authorize_user
      end
    end
  end
end
