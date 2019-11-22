module Resolvers
  module QueryType
    class PoliciesResolver < Resolvers::BaseResolver
      type Types::PolicyType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil,limit: nil)
        Policy.page(page).per(limit)
        @q = Policy.ransack(filter.as_json)
        @q.result.page(page).per(limit) 
        # ::context[:current_user].page(page).per(limit)
      end

      # def ready?(args)
      #   authorize_user
      # end
    end
  end
end