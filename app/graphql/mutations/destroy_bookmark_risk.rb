#frozen_string_literal: true

module Mutations
  class DestroyBookmarkRisk < Mutations::BaseMutation
    graphql_name "DestroyBookmarkRisk"
    argument :id, ID, required: true

    field :bookmark_risk, Types::BookmarkRiskType, null: true

    def resolve(id:)
      bookmark_risk = BookmarkRisk.find(id)
      success = bookmark_risk.destroy

      MutationResult.call(
        obj: {bookmark_risk: bookmark_risk},
        success: success,
        errors: bookmark_risk.errors
      )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(',')}"
      )
    end

    # def ready?(args)
    #   authorize_user
    # end

  end
end
