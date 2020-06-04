module Resolvers
  module QueryType
    module Preparer
      class PreparerCreatedControlsResolver < Resolvers::BaseResolver
        type Types::ControlType.collection_type, null: true
        argument :filter, Types::BaseScalar, required: false
        argument :page, Int, required: false
        argument :limit, Int, required: false

        def resolve(filter:, page: nil,limit: nil)
          Control.page(page).per(limit)
          @q = Control.ransack(filter.as_json)
          @q.sorts = 'created_at desc' if @q.sorts.empty?
          @q.result(distinct: true).page(page).per(limit)
          # ::context[:current_user].page(page).per(limit)
        end

        def ready?(args)
          authorize_user
        end
      end
    end
  end
end
