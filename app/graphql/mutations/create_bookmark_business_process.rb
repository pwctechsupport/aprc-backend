#frozen_string_literal: true

module Mutations
  class CreateBookmarkBusinessProcess < Mutations::BaseMutation
    argument :business_process_id, ID, required: true

    field :bookmark_business_process, Types::BookmarkBusinessProcessType, null: true

    def resolve(args)
      current_user = context[:current_user]

      bookmark_business_process = current_user.bookmark_business_processes.where(user_id: current_user.id, business_process_id: args[:business_process_id]).first
      if bookmark_business_process
        bookmark_business_process.update_attributes(args.to_h)
      else
        bookmark_business_process = current_user.bookmark_business_processes.create!(args.to_h)
      end

      # bookmark_business_process = current_user.bookmark_business_processs.create!(args.to_h)
      MutationResult.call(
        obj: {bookmark_business_process: bookmark_business_process},
        success: bookmark_business_process.persisted?,
        errors: bookmark_business_process.errors
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
