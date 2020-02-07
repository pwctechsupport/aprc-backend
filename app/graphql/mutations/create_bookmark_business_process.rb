#frozen_string_literal: true

module Mutations
  class CreateBookmarkBusinessProcess < Mutations::BaseMutation
    argument :business_process_id, ID, required: true

    field :bookmark, Types::BookmarkType, null: true

    def resolve(business_process_id:, **args)
      current_user = context[:current_user]
      business_process = BusinessProcess.find(business_process_id)
      name = business_process&.name
      bookmark = Bookmark.create!(user_id: current_user&.id, originator: business_process, name: name)

      # bookmark_business_process = current_user.bookmark_business_processs.create!(args.to_h)
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
