#frozen_string_literal: true

module Mutations
  class DestroyBookmark < Mutations::BaseMutation
    graphql_name "DestroyBookmarkByChoice"
    argument :ids, [ID], required: true

    field :bookmark, Boolean, null: false

    def resolve(ids:)
      bookmark = Bookmark.where(id: ids)
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
