#frozen_string_literal: true

module Mutations
  class CreateBookmarkControl < Mutations::BaseMutation
    argument :control_id, ID, required: true

    field :bookmark, Types::BookmarkType, null: true

    def resolve(control_id:, **args)
      current_user = context[:current_user]
      control = Control.find(control_id)
      name = control.description
      bookmark = Bookmark.create!(user_id: current_user.id, originator: control, name: name)

      # bookmark = current_user.bookmarks.create!(args.to_h)
      MutationResult.call(
        obj: {bookmark: bookmark},
        success: bookmark.persisted?,
        errors: bookmark.errors
      )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end

    def ready?(args)
      authorize_user
    end

  end
end
