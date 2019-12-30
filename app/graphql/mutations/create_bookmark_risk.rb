#frozen_string_literal: true

module Mutations
  class CreateBookmarkRisk < Mutations::BaseMutation
    argument :risk_id, ID, required: true

    field :bookmark_risk, Types::BookmarkRiskType, null: true

    def resolve(args)
      current_user = context[:current_user]

      bookmark_risk = current_user.bookmark_risks.where(user_id: current_user.id, risk_id: args[:risk_id]).first
      if bookmark_risk
        bookmark_risk.update_attributes(args.to_h)
      else
        bookmark_risk = current_user.bookmark_risks.create!(args.to_h)
      end

      # bookmark_risk = current_user.bookmark_risks.create!(args.to_h)
      MutationResult.call(
        obj: {bookmark_risk: bookmark_risk},
        success: bookmark_risk.persisted?,
        errors: bookmark_risk.errors
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
