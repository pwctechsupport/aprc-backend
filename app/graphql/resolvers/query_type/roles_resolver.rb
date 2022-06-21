module Resolvers
  module QueryType
    class RolesResolver < Resolvers::BaseResolver
      type Types::RoleType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil,limit: nil)
        Role.page(page).per(limit)
        @q = Role.ransack(filter.as_json)
        @q.result(distinct: true).page(page).per(limit)
      end

      def ready?(args)
        authorize_user
      end
    end
  end
end