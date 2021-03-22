module Resolvers
  module QueryType
    class ControlsResolver < Resolvers::BaseResolver
      type Types::ControlType.collection_type, null: true
      argument :filter, Types::BaseScalar, required: false
      argument :page, Int, required: false
      argument :limit, Int, required: false

      # def resolve(filter:, page: nil,limit: nil)
      #   Control.page(page).per(limit)
      #   @q = Control.ransack(filter.as_json)
      #   @q.result(distinct: true).page(page).per(limit)
      #   # ::context[:current_user].page(page).per(limit)
      # end

      def resolve(filter:, page: nil,limit: nil)
        if context[:current_user].has_role?(:admin_reviewer)
          Control.page(page).per(limit)
          @q = Control.ransack(filter.as_json)
          @q.result(distinct: true).order(status: :desc, updated_at: :desc).page(page).per(limit)
        elsif context[:current_user].has_role?(:user)
          data = context[:current_user].policies_by_categories
          @q = data.ransack(filter.as_json)
          @q.result(distinct: true).page(page).per(limit) 
        else
          Control.page(page).per(limit)
          @q = Control.ransack(filter.as_json)
          @q.result(distinct: true).page(page).per(limit) 
        end
      end
      

      def ready?(args)
        authorize_user
      end
    end
  end
end