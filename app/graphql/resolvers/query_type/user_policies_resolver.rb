module Resolvers
  module QueryType
    class UserPoliciesResolver < Resolvers::BaseResolver
      type Types::PolicyType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil,limit: nil)
        data = context[:current_user].policies_by_categories
        if context[:current_user].has_role?(:user)
          @q = data.released.ransack(filter.as_json)
        else
          @q = data.ransack(filter.as_json)
        end
        @q.sorts = 'title asc' if @q.sorts.empty?
        @q.result(distinct: true).page(page).per(limit)
        # ::context[:current_user].page(page).per(limit)
      end

      def ready?(args)
        authorize_user
      end
    end
  end
end
