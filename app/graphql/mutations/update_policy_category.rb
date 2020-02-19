# frozen_string_literal: true

module Mutations
  class UpdatePolicyCategory < Mutations::BaseMutation
    graphql_name "UpdatePolicyCategory"

    argument :id, ID, required: true
    argument :name, String, required: false
    argument :policy_ids, [ID], required: false


    field :policy_category, Types::PolicyCategoryType, null: false

    def resolve(id:, **args)
      current_user = context[:current_user]
      policy_category = PolicyCategory.find(id)
      if policy_category.draft?
        raise GraphQL::ExecutionError, "Draft Cannot be created until another Draft is Approved/Rejected by an Admin"
      else
        policy_category.attributes = args
        policy_category.save_draft
        admin = User.with_role(:admin_reviewer).pluck(:id)
        Notification.send_notification(admin, policy_category&.name, policy_category&.name,policy_category, current_user&.id)
      end
      MutationResult.call(
        obj: { policy_category: policy_category },
        success: policy_category.persisted?,
        errors: policy_category.errors
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