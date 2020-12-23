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
        if context[:current_user].has_role?(:admin_reviewer)
          @q.result(distinct: true).order(status: :desc, updated_at: :desc).page(page).per(limit)
        else
          @q.result(distinct: true).page(page).per(limit) 
        end
      end

      def ready?(args)
        authorize_user
      end
    end
  end
end