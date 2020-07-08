module Resolvers
  module QueryType
    class UserResourceVisitsResolver < Resolvers::BaseResolver
      type Types::UserResourceVisitType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil, limit: nil)
        current_user = context[:current_user]
        @q = UserResourceVisit&.where(user_id: current_user&.id).ransack(filter.as_json)
        @q.sorts = 'recent_visit desc' if @q.sorts.empty?
        @q.result(distinct: true).page(page).per(limit)
      end
      
      def ready?(args)
        authorize_user
      end
    end
  end
end


