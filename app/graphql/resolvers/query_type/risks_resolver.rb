module Resolvers
  module QueryType
    class RisksResolver < Resolvers::BaseResolver
      type Types::RiskType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil,limit: nil)
        Risk.page(page).per(limit)
        @q = Risk.ransack(filter.as_json)
        @q.result(distinct: true).page(page).per(limit)  
        # ::context[:current_user].page(page).per(limit)
      end

      # def ready?(args)
      #   authorize_user
      # end
    end
  end
end