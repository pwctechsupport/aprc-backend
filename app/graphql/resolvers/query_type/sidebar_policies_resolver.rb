module Resolvers
  module QueryType
    class SidebarPoliciesResolver < Resolvers::BaseResolver
      type Types::PolicyType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil,limit: nil)
        Policy.page(page).per(limit)
        if context[:current_user].has_role?(:user)
          @q = Policy.released.ransack(filter.as_json)
        else
          @q = Policy.ransack(filter.as_json)
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
