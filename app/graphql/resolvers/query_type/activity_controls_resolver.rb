module Resolvers
  module QueryType
    class ActivityControlsResolver < Resolvers::BaseResolver
      type Types::ActivityControlType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil, limit: nil)
        current_user = context[:current_user]
        @q = ActivityControl.where(user_id: current_user.id).ransack(filter.as_json)
        @q.result(distinct: true).page(page).per(limit)
      end
    end
  end
end
