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
        user_draft= user.draft.reify
        if args[:publish] === true
          if user.user_reviewer_id.present? && (user.user_reviewer_id != current_user.id)
            raise GraphQL::ExecutionError, "This Draft has been reviewed by another Admin."
          elsif !user.user_reviewer_id.present?
            if user.user_policy_categories.drafted.present?
              if !user.user_policy_categories.published.present?
                user.deep_publish!
                user.update(user_reviewer_id: current_user.id)
                User.change_role(user.id, user_draft.role)
              else
                polcat_id = user.user_policy_categories.published.pluck(:policy_category_id)
                user.user_policy_categories.published.where(policy_category_id: polcat_id).destroy_all
                user.deep_publish!
                user.update(user_reviewer_id: current_user.id)
                User.change_role(user.id, user_draft.role)
              end
            else
              user.deep_publish!
              user.update(user_reviewer_id: current_user.id)
              User.change_role(user.id, user_draft.role)
            end
          else
            if user.user_policy_categories.drafted.present?
              if !user.user_policy_categories.published.present?
                user.deep_publish!
                User.change_role(user.id, user_draft.role)
              else
                polcat_id = user.user_policy_categories.published.pluck(:policy_category_id)
                user.user_policy_categories.published.where(policy_category_id: polcat_id).destroy_all
                user.deep_publish!
                User.change_role(user.id, user_draft.role)
              end
            else
              user.deep_publish!
              User.change_role(user.id, user_draft.role)
            end
          end
        else
          if user.user_reviewer_id.present? && (user.user_reviewer_id != current_user.id)
            raise GraphQL::ExecutionError, "This Draft has been reviewed by another Admin."
          elsif user.user_policy_categories.drafted.present?
            user.user_policy_categories.drafted.destroy_all
            user.draft.revert!
          else
            user.draft.revert!
          end
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