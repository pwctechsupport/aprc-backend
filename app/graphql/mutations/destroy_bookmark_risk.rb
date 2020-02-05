#frozen_string_literal: true

module Mutations
  class DestroyBookmarkRisk < Mutations::BaseMutation
    graphql_name "DestroyBookmarkRisk"
    argument :id, ID, required: true

    field :bookmark, Types::BookmarkType, null: true

    def resolve(id:)
      risk = Risk.find(id)
      bookmark = Bookmark.find_by(originator: risk)
      success = bookmark.destroy

      MutationResult.call(
        obj: {bookmark: bookmark},
        success: success,
        errors: bookmark.errors
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
