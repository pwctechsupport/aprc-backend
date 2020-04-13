module Resolvers
  module QueryType
    class ResourcesResolver < Resolvers::BaseResolver
      type Types::ResourceType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil,limit: nil)
        Resource.page(page).per(limit)
        @q = Resource.ransack(filter.as_json)
        @q.result(distinct: true).page(page).per(limit) 
        # ::context[:current_user].page(page).per(limit)
      end

      # def ready?(args)
      #   authorize_user
      # end
    end
  end
end