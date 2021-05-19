# frozen_string_literal: true

module Resolvers
  module QueryType
    # PolicyRisksResolver
    class PolicyRisksResolver < Resolvers::BaseResolver
      type Types::PolicyRiskType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil, limit: nil)
        data = \
          current_user.is_user? ? user_policies : PolicyRisk.page(page).per(limit)
        @q = data.ransack(filter.as_json)
        @q.result(distinct: true).order(updated_at: :desc).page(page).per(limit)
      end

      def ready?(_args)
        authorize_user
      end

      private

      def current_user
        context[:current_user]
      end

      def user_policies
        @policies = current_user.policies_by_categories
        Risk.where(id: risk_ids.flatten)
      end

      def risk_ids
        policies = \
          @policies.where(status: %w[release ready_for_edit waiting_for_approval])
        policies.map(&:risk_ids)
      end
    end
  end
end
