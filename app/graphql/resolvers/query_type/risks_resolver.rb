module Resolvers
  module QueryType
    class RisksResolver < Resolvers::BaseResolver
      type Types::RiskType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false
      argument :sort_by, Types::Enums::RiskColumns, required: false
      argument :sort_order, Types::Enums::SortOrder, required:false

      def resolve(filter:, page: nil,limit: nil, sort_by: nil, sort_order: nil)
        Risk.page(page).per(limit)
        @q = Risk.ransack(filter.as_json)
        if sort_by.present? && sort_order.present?
          @q.sorts = "#{sort_by} #{sort_order}" if @q.sorts.empty?
        end
        @q.result(distinct: true).page(page).per(limit)  
        # ::context[:current_user].page(page).per(limit)
      end

      # def ready?(args)
      #   authorize_user
      # end
    end
  end
end