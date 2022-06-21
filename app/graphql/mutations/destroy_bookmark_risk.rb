#frozen_string_literal: true

module Mutations
  class DestroyBookmarkRisk < Mutations::BaseMutation
    graphql_name "DestroyBookmarkRisk"
    argument :ids, [ID], required: true

    field :bookmark, Boolean, null: false

    def resolve(ids:)
      risk = Risk.where(id:ids)
      bookmark = Bookmark.where(originator: risk)
      success = bookmark.destroy_all

      MutationResult.call(
        obj: {bookmark: bookmark},
        success: success,
        errors: success
      )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(',')}"
      )
    end

    def ready?(args)
      authorize_user
    end

  end
end
