#frozen_string_literal: true

module Mutations
  class DestroyBookmarkControl < Mutations::BaseMutation
    graphql_name "DestroyBookmarkControl"
    argument :id, ID, required: true

    field :bookmark_control, Types::BookmarkControlType, null: true

    def resolve(id:)
      bookmark_control = BookmarkControl.find(id)
      success = bookmark_control.destroy

      MutationResult.call(
        obj: {bookmark_control: bookmark_control},
        success: success,
        errors: bookmark_control.errors
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
