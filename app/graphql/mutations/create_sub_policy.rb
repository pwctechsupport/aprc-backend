module Mutations
  class CreateSubPolicy < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :title, String, required: true
    argument :description, String, required: true
    argument :parent_id, ID, required: true
    argument :reference_ids, [ID], required: false
    argument :status, Types::Enums::Status, required: false
    argument :business_process_ids, [ID], required: true
    argument :control_ids, [ID], required: true
    argument :risk_ids, [ID], required: true
    argument :resource_ids, [ID], required: false
    argument :created_by, String, required: false
    argument :last_updated_by, String, required: false
    argument :is_submitted, Boolean, required: false



    # return type from the mutation
    field :policy, Types::PolicyType, null: true

    def resolve(args)
      current_user = context[:current_user]
      args[:created_by] = current_user&.name || "User with ID#{current_user&.id}"
      args[:last_updated_by] = current_user&.name || "User with ID#{current_user&.id}"
      if args[:business_process_ids].present?
        buspro = args[:business_process_ids]
        args.delete(:business_process_ids)
      end
      if args[:risk_ids].present?
        risk = args[:risk_ids]
        args.delete(:risk_ids)
      end
      if args[:control_ids].present?
        control = args[:control_ids]
        args.delete(:control_ids)
      end
      if args[:reference_ids].present?
        reference = args[:reference_ids]
        args.delete(:reference_ids)
      end
      if args[:resource_ids].present?
        resource = args[:resource_ids]
        args.delete(:resource_ids)
      end
      policy = current_user.policies.new(args.to_h)
      policy.save_draft

      
      admin = User.with_role(:admin_reviewer).pluck(:id)
      if policy.id.present?
        if buspro.present?
          buspro.each do |bus|
            pol_bus = PolicyBusinessProcess.new(policy_id: policy&.id, business_process_id: bus )
            pol_bus.save_draft
          end 
        end
        if risk.present?
          risk.each do |ris|
            pol_ris = PolicyRisk.new(policy_id: policy&.id, risk_id: ris )
            pol_ris.save_draft
          end 
        end
        if control.present?
          control.each do |con|
            pol_con = PolicyControl.new(policy_id: policy&.id, control_id: con )
            pol_con.save_draft
          end 
        end
        if reference.present?
          reference.each do |ref|
            pol_ref = PolicyReference.new(policy_id: policy&.id, reference_id: ref )
            pol_ref.save_draft
          end 
        end
        if resource.present?
          resource.each do |res|
            pol_res = PolicyResource.new(policy_id: policy&.id, resource_id: res )
            pol_res.save_draft
          end 
        end
        policy.update(created_by: policy&.user&.name, status: "waiting_for_review")
        Notification.send_notification(admin, policy&.title, policy&.title, policy, current_user&.id, "request_draft")
      else
        raise GraphQL::ExecutionError, "The exact same draft cannot be duplicated"
      end

      # policy = Policy.create!(args.to_h)
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
  end
end