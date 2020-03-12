module Mutations
  class ReviewResourceDraft < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :publish, Boolean, required: true
    argument :id, ID, required: true
    
    # return type from the mutation
    field :resource, Types::ResourceType, null: true

    def resolve(args)
      current_user = context[:current_user]
      resource = Resource.find(args[:id])

      if current_user.present? && current_user.has_role?(:admin_reviewer)
        resource_draft = resource.draft
        if args[:publish] === true
          if resource.user_reviewer_id.present? && (resource.user_reviewer_id != current_user.id)
            raise GraphQL::ExecutionError, "This Draft has been reviewed by another Admin."
          elsif !resource.user_reviewer_id.present?
            resource_draft.publish!
            resource.update(user_reviewer_id: current_user.id)
          else
            resource_draft.publish!
            resource.update(user_reviewer_id: current_user.id)
          end
        else
          if resource.user_reviewer_id.present? && (resource.user_reviewer_id != current_user.id)
            raise GraphQL::ExecutionError, "This Draft has been reviewed by another Admin."
          end
          resource_draft.revert!
        end 
      else
        raise GraphQL::ExecutionError, "User is not an Admin."
      end

      # resource = resource.create!(args.to_h)
      MutationResult.call(
          obj: { resource: resource },
          success: resource.persisted?,
          errors: resource.errors
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