module Resolvers
  module QueryType
    class NotificationsResolver < Resolvers::BaseResolver
      type Types::NotificationType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil, limit: nil)
        Notification.page(page).per(limit)
        @q = Notification.ransack(filter.as_json)
        @q.result.page(page).per(limit)
      end
    end
  end
end
