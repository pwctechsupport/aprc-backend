module Resolvers
  module QueryType
    module Navigator
      class NavigatorPolicyCategoriesResolver < Resolvers::BaseResolver
        type Types::PolicyCategoryType.collection_type, null: true
        argument :filter, Types::BaseScalar, required: false
        argument :page, Int, required: false
        argument :limit, Int, required: false

        def resolve(filter:, page: nil,limit: nil)
          PolicyCategory.page(page).per(limit)
          @q = PolicyCategory.ransack(filter.as_json)
          @q.sorts = 'name asc' if @q.sorts.empty?
          @q.result(distinct: true).page(page).per(limit)
          # ::context[:current_user].page(page).per(limit)
        end

        def ready?(args)
          authorize_user
        end
      end
    end
  end
end