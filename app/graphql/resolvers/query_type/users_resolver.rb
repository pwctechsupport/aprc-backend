module Resolvers
  module QueryType
    class UsersResolver < Resolvers::BaseResolver
      type Types::UserType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil,limit: nil)
        # User.page(page).per(limit)
        @q = User.ransack(filter.as_json)
        @q.result(distinct: true).page(page).per(limit)
      end

      # def ready?(args)
      #   authorize_user
      # end
    end
  end
end