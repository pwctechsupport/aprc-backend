module Resolvers
  module QueryType
    class PoliciesResolver < Resolvers::BaseResolver
      type Types::PolicyType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil,limit: nil)
        if context[:current_user].has_role?(:user)
          data = context[:current_user].policies_by_categories
          @q = data.ransack(filter.as_json)
        else
          if filter.present?
            if filter.as_json.first[1].present?
              @q = Policy.all.ransack(filter.as_json)
            else
              @q = Policy.where(ancestry: nil).ransack(filter.as_json)
            end
          else
            @q = Policy.where(ancestry: nil).ransack(filter.as_json)
          end
        end
        
        @q.result(distinct: true).page(page).per(limit)
        # ::context[:current_user].page(page).per(limit)
      end

      def ready?(args)
        authorize_user
      end
    end
  end
end