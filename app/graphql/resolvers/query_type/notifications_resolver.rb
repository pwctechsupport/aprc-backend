module Resolvers
  module QueryType
    class NotificationsResolver < Resolvers::BaseResolver
      type Types::NotificationType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil, limit: nil)
        current_user = context[:current_user]
        if filter[:title_or_originator_type_or_sender_user_name_cont]&.downcase.include?("system")
          @q = Notification.where(user_id: current_user&.id, is_general: true).ransack(filter.as_json)
        else
          @q = Notification.where(user_id: current_user&.id, is_general: false).ransack(filter.as_json)
        end
        @q.sorts = 'created_at desc' if @q.sorts.empty?
        @q.result(distinct: true).page(page).per(limit)
      end

      def ready?(args)
        authorize_user
      end
    end
  end
end


