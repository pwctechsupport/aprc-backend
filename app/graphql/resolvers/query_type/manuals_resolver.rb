module Resolvers
  module QueryType
    class ManualsResolver < Resolvers::BaseResolver
      type Types::ManualType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil,limit: nil)
        Manual.page(page).per(limit)
        @q = Manual.ransack(filter.as_json)
        @q.result.page(page).per(limit)  
        # ::context[:current_user].page(page).per(limit)
      end

      def ready?(args)
        authorize_user
      end
    end
  end
end