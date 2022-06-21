module Resolvers
  module QueryType
    class ReviewerUsersStatusResolver < Resolvers::BaseResolver
      type Types::UserType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil,limit: nil)
        User.page(page).per(limit)
        @q = User.ransack(filter.as_json)
        
        @q1 = @q.result.where(status:"waiting_for_review")
        @q2 = @q.result.where(status:"waiting_for_approval")
        @q0 = @q1 + @q2
        @q0 = @q0.sort_by(&:updated_at).reverse
        

        @q3 = @q.result.where.not(status: ["waiting_for_review", "waiting_for_approval"])
        @q3 = @q3.sort_by(&:created_at)

        @q_final = @q0.push(*@q3)
        ids = @q_final.map(&:id)
        if ids.count != 0
          @q = User.where(id: ids).order("FIELD(id, #{ids.join(',')})").all.ransack
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
