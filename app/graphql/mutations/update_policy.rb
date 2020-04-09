# frozen_string_literal: true

module Mutations
  class UpdatePolicy < Mutations::BaseMutation
    graphql_name "UpdatePolicy"

    argument :id, ID, required: true
    argument :title, String, required: false
    argument :description, String, required: false
    argument :policy_category_id, ID, required: false
    argument :it_system_ids, [ID], required: false
    argument :resource_ids, [ID], required: false
    argument :business_process_ids, [ID], required: false
    argument :parent_id, ID, required: false
    argument :status, Types::Enums::Status, required: false
    argument :reference_ids, [ID], required: false
    argument :risk_ids, [ID], required: false
    argument :control_ids, [ID], required: false
    argument :last_updated_by, String, required: false
    argument :user_id, ID, required: false


    field :policy, Types::PolicyType, null: false

    def resolve(id:, **args)
      current_user = context[:current_user]
      args[:user_id] = current_user.id
      policy = Policy.find(id)
      if policy&.request_edits&.last&.approved?
        if policy&.draft?
          raise GraphQL::ExecutionError, "Draft Cannot be created until another Draft is Approved/Rejected by an Admin"
        else
          args[:last_updated_by] = current_user&.name || "User with ID#{current_user&.id}"
          policy&.attributes = args
          policy&.save_draft
        end
      else  
        raise GraphQL::ExecutionError, "Request not granted. Please Check Your Request Status"
      end

      MutationResult.call(
        obj: { policy: policy },
        success: policy.persisted?,
        errors: policy.errors
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