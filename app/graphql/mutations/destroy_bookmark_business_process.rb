#frozen_string_literal: true

module Mutations
  class DestroyBookmarkBusinessProcess < Mutations::BaseMutation
    graphql_name "DestroyBookmarkBusinessProcess"
    argument :id, ID, required: true

    field :bookmark_business_process, Types::BookmarkBusinessProcessType, null: true

    def resolve(id:)
      bookmark_business_process = BookmarkBusinessProcess.find(id)
      success = bookmark_business_process.destroy

      MutationResult.call(
        obj: {bookmark_business_process: bookmark_business_process},
        success: success,
        errors: bookmark_business_process.errors
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
