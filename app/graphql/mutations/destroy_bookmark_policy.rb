#frozen_string_literal: true

module Mutations
  class DestroyBookmarkPolicy < Mutations::BaseMutation
    graphql_name "DestroyBookmarkPolicy"
    argument :id, ID, required: true

    field :bookmark, Types::BookmarkType, null: true

    def resolve(id:)
      policy = Policy.find(id)
      bookmark = Bookmark.find_by(originator: policy)
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
