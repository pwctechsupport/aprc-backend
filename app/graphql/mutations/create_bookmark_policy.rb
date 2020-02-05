#frozen_string_literal: true

module Mutations
  class CreateBookmarkPolicy < Mutations::BaseMutation
    argument :policy_id, ID, required: true

    field :bookmark, Types::BookmarkType, null: true

    def resolve(policy_id:, **args)
      current_user = context[:current_user]
      policy = Policy.find(policy_id)
      name = policy.policy_category.name
      bookmark = Bookmark.create!(user_id: current_user.id, originator: policy, name: name)

      # bookmark_policy = current_user.bookmark_policies.create!(args.to_h)
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
