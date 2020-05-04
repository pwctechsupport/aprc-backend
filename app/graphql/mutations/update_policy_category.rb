# frozen_string_literal: true

module Mutations
  class UpdatePolicyCategory < Mutations::BaseMutation
    graphql_name "UpdatePolicyCategory"

    argument :id, ID, required: true
    argument :name, String, required: false
    argument :policy_ids, [ID], required: false
    argument :last_updated_by, String, required: false
    argument :status, Types::Enums::Status, required: false
    argument :policy, [ID], as: :policy_ids,required: false




    field :policy_category, Types::PolicyCategoryType, null: false

    def resolve(id:, **args)
      current_user = context[:current_user]
      policy_category = PolicyCategory.find(id)

      if policy_category&.request_edits&.last&.approved?
        if policy_category.draft?
          raise GraphQL::ExecutionError, "Draft Cannot be created until another Draft is Approved/Rejected by an Admin"
        else
          args[:last_updated_by] = current_user&.name || "User with ID#{current_user&.id}"
          if args[:policy_ids].present?
            args[:policy] = args[:policy_ids].map{|x| Policy.find(x&.to_i).title}
          end
          policy_category.attributes = args
          policy_category.save_draft
          admin = User.with_role(:admin_reviewer).pluck(:id)
          if policy_category.draft.present?
            Notification.send_notification(admin, policy_category&.name, policy_category&.name,policy_category, current_user&.id, "request draft")
          else
          end
        end
      else
        raise GraphQL::ExecutionError, "Request not granted. Please Check Your Request Status"
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