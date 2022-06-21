#frozen_string_literal: true

module Mutations
  class CreateBookmarkRisk < Mutations::BaseMutation
    argument :risk_id, ID, required: true

    field :bookmark, Types::BookmarkType, null: true

    def resolve(risk_id:, **args)
      current_user = context[:current_user]
      risk = Risk.find(risk_id)
      name = risk&.name
      bookmark = Bookmark.create!(user_id: current_user&.id, originator: risk, name: name)

      # bookmark = current_user.bookmark_risks.create!(args.to_h)
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
