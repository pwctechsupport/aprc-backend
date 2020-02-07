module Mutations
  class ReviewUserDraft < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :publish, Boolean, required: true
    argument :id, ID, required: true
    
    # return type from the mutation
    field :user, Types::UserType, null: true

    def resolve(args)
      current_user = context[:current_user]
      user = User.find(args[:id])

      if current_user.present? && current_user.has_role?(:admin)
        user_draft= user.draft
        if args[:publish] === true
          if user.user_reviewer_id.present? && (user.user_reviewer_id != current_user.id)
            raise GraphQL::ExecutionError, "This Draft has been reviewed by another Admin."
          elsif !user.user_reviewer_id.present?
            user_draft.publish!
            user.update(user_reviewer_id: current_user.id)
          else
            user_draft.publish!
          end
        else
          user_draft.revert!
        end 
      else
        raise GraphQL::ExecutionError, "User is not an Admin."
      end

      # user = user.create!(args.to_h)
      MutationResult.call(
          obj: { user: user },
          success: user.persisted?,
          errors: user.errors
        )
    rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end
    def ready?(args)
      authorize_user
    end
  end
end