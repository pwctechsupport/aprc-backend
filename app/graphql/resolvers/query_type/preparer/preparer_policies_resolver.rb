module Resolvers
  module QueryType
    module Preparer
      class PreparerPoliciesResolver < Resolvers::BaseResolver
        type Types::PolicyType.collection_type, null: true
        argument :filter, Types::BaseScalar, required: false
        argument :page, Int, required: false
        argument :limit, Int, required: false

        def resolve(filter:, page: nil,limit: nil)
          Policy.page(page).per(limit)
          @q = Policy.ransack(filter.as_json)
          @q.sorts = 'updated_at desc' if @q.sorts.empty?
          @q.result(distinct: true).page(page).per(limit)
          # ::context[:current_user].page(page).per(limit)
        end
      end
    end
  end
end
