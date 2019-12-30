#frozen_string_literal: true

module Mutations
  class CreateBookmarkControl < Mutations::BaseMutation
    argument :control_id, ID, required: true

    field :bookmark_control, Types::BookmarkControlType, null: true

    def resolve(args)
      current_user = context[:current_user]

      bookmark_control = current_user.bookmark_controls.where(user_id: current_user.id, control_id: args[:control_id]).first
      if bookmark_control
        bookmark_control.update_attributes(args.to_h)
      else
        bookmark_control = current_user.bookmark_controls.create!(args.to_h)
      end

      # bookmark_control = current_user.bookmark_controls.create!(args.to_h)
      MutationResult.call(
        obj: {bookmark_control: bookmark_control},
        success: bookmark_control.persisted?,
        errors: bookmark_control.errors
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
