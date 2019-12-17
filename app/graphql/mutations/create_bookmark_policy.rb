#frozen_string_literal: true

module Mutations
  class CreateBookmarkPolicy < Mutations::BaseMutation
    argument :policy_id, ID, required: true

    field :bookmark_policy, Types::BookmarkPolicyType, null: true

    def resolve(args)
      current_user = context[:current_user]
      bookmark_policy = current_user.bookmark_policies.create!(args.to_h)
      MutationResult.call(
        obj: {bookmark_policy: bookmark_policy},
        success: bookmark_policy.persisted?,
        errors: bookmark_policy.errors
      )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end

    # def ready?(args)
    #   authorize_user
    # end

  end
end
