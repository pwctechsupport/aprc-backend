module Resolvers
  module QueryType
    class RisksResolver < Resolvers::BaseResolver
      type Types::RiskType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil,limit: nil)
        if context[:current_user].has_role?(:admin_reviewer)
          Risk.page(page).per(limit)
          @q = Risk.ransack(filter.as_json)
          @q.result(distinct: true).order(status: :desc, updated_at: :desc).page(page).per(limit)
        elsif context[:current_user].has_role?(:user)
          policies = context[:current_user].policies_by_categories
          policies = policies.where(status: ["release", "ready_for_edit", "waiting_for_approval"])
          risk_ids = policies.map{|policy| policy.risks.ids}
          data = Risk.where(id: risk_ids.flatten)
          @q = data.ransack(filter.as_json)
          @q.result(distinct: true).page(page).per(limit) 
        else
          Risk.page(page).per(limit)
          @q = Risk.ransack(filter.as_json)
          @q.result(distinct: true).page(page).per(limit) 
        end
      end

      def ready?(args)
        authorize_user
      end
    end
  end
end