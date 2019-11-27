module Resolvers
  module QueryType
    class ItSystemsResolver < Resolvers::BaseResolver
      type Types::ItSystemType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil,limit: nil)
        ItSystem.page(page).per(limit)
        @q = ItSystem.ransack(filter.as_json)
        @q.result.page(page).per(limit)  
        # ::context[:current_user].page(page).per(limit)
      end

      # def ready?(args)
      #   authorize_user
      # end
    end
  end
end