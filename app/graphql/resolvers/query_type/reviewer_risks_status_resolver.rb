module Resolvers
  module QueryType
    class ReviewerRisksStatusResolver < Resolvers::BaseResolver
      type Types::RiskType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil,limit: nil)
        Risk.page(page).per(limit)
        @q = Risk.ransack(filter.as_json)
        
        @q1 = @q.result.where(status:"waiting_for_review")
        @q1 = @q1.sort_by(&:updated_at).reverse

        @q2 = @q.result.where(status:"waiting_for_approval")
        @q2 = @q2.sort_by(&:updated_at).reverse
        
        @q3 = @q.result.where(status:"ready_for_edit")
        @q3 = @q3.sort_by(&:updated_at).reverse

        @q4 = @q.result.where(status:"draft")
        @q4 = @q4.sort_by(&:updated_at).reverse

        @q5 = @q.result.where(status:"release")
        @q5 = @q5.sort_by(&:updated_at).reverse
        
        @q6 = @q.result.where(status:nil)
        @q6 = @q6.sort_by(&:updated_at).reverse

        @q_final = @q1.push(*@q2,*@q3,*@q4,*@q5, *@q6)
        ids = @q_final.map(&:id)
        if ids.count != 0
          @q = Risk.where(id: ids).order("FIELD(id, #{ids.join(',')})").all.ransack(filter.as_json)
        end
        @q.result(distinct: true).page(page).per(limit)
        # ::context[:current_user].page(page).per(limit)
      end

      def ready?(args)
        authorize_user
      end
    end
  end
end
