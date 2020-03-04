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

    
    field :policy, Types::PolicyType, null: false

    def resolve(id:, **args)
      current_user = context[:current_user]
      policy = Policy.find(id)
      if policy&.request_edits&.last&.approved?
        if policy&.draft?
          raise GraphQL::ExecutionError, "Draft Cannot be created until another Draft is Approved/Rejected by an Admin"
        else
          policy&.attributes = args
          policy&.save_draft
          admin_prep = User.with_role(:admin_preparer).pluck(:id)
          admin_rev = User.with_role(:admin_reviewer).pluck(:id)
          admin_main = User.with_role(:admin).pluck(:id)
          all_admin = admin_prep + admin_rev + admin_main
          admin = all_admin.uniq
          Notification.send_notification(admin, policy&.title, policy&.description,policy, current_user&.id, "request_draft")
          if policy.references.present?
            ref= policy&.references
            polisi = Policy.find(id)
            ref.each do |r|
              namu = r&.policies&.pluck(:title).reject{ |k| k==polisi.title}
              nama = namu.join(", ")
              Notification.send_notification(admin,"Policy with the same reference" ,"#{policy.title} with #{r.name} reference has the same references with #{nama}.",policy, current_user&.id, "same_reference" )  
            end
          else
          end
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