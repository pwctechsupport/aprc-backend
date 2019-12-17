#frozen_string_literal: true

module Mutations
  class DestroyBookmarkPolicy < Mutations::BaseMutation
    graphql_name "DestroyBookmarkPolicy"
    argument :id, ID, required: true

    field :bookmark_policy, Types::BookmarkPolicyType, null: true

    def resolve(id:)
      bookmark_policy = BookmarkPolicy.find(id)
      success = bookmark_policy.destroy

      MutationResult.call(
        obj: {bookmark_policy: bookmark_policy},
        success: success,
        errors: bookmark_policy.errors
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
