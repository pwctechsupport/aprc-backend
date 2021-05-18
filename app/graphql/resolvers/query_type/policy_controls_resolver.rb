# frozen_string_literal: true

module Resolvers
  module QueryType
    # PolicyControlsResolver
    class PolicyControlsResolver < Resolvers::BaseResolver
      type Types::PolicyControlType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      def resolve(filter:, page: nil, limit: nil)
        data = \
          user.is_user? ? user_policies : PolicyControl.page(page).per(limit)
        @q = data.ransack(filter.as_json)
        @q.result(distinct: true).order(updated_at: :desc).page(page).per(limit)
      end

      def ready?(_args)
        authorize_user
      end

      private

      def user
        context[:current_user]
      end

      def user_policies
        @policies = user.policies_by_categories
        Control.where(id: control_ids.flatten)
      end

      def control_ids
        policies = \
          @policies.where(status: %w[release ready_for_edit waiting_for_approval])
        policies.map(&:control_ids)
      end
    end
  end
end
