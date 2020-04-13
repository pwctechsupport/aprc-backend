module Resolvers
  module QueryType
    class BusinessProcessesResolver < Resolvers::BaseResolver
      type Types::BusinessProcessType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil,limit: nil)
        BusinessProcess.page(page).per(limit)
        @q = BusinessProcess.ransack(filter.as_json)
        @q.result(distinct: true).page(page).per(limit)  
        # ::context[:current_user].page(page).per(limit)
      end

      # def ready?(args)
      #   authorize_user
      # end
    end
  end
end