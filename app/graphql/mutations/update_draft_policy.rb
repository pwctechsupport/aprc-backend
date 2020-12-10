module Mutations
  class UpdateDraftPolicy < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :parent_id, ID, required: false
    argument :id, ID, required: true
    argument :title, String, required: false
    argument :description, String, required: false
    argument :policy_category_id, ID, required: false 
    argument :resource_id, ID, required: false
    argument :it_system_ids, [ID], required: false
    argument :resource_ids, [ID], required: false
    argument :status, Types::Enums::Status, required: false
    argument :business_process_ids, [ID], required: false
    argument :control_ids, [ID], required: false
    argument :risk_ids, [ID], required: false
    argument :reference_ids, [ID], required: false
    argument :last_updated_by, String, required: false
    argument :last_updated_at, String, required: false


    # return type from the mutation
    field :policy, Types::PolicyType, null: true

    def resolve(id:, **args)
      current_user = context[:current_user]
      policy = Policy.find(id)
      if policy.user_id == current_user&.id
        if args[:business_process_ids].present? || args[:risk_ids].present? || args[:reference_ids].present? || args[:control_ids].present? || args[:resource_ids].present?
          args[:is_related] = true
        end
        args[:last_updated_by] = current_user&.name || "User with ID#{current_user&.id}"
        args[:last_updated_at] = Time.now
        prev_buspro = []
        prev_risk = []
        prev_control = []
        prev_reference = []
        prev_resource = []
        if args[:business_process_ids].present?
          buspro = args[:business_process_ids]
          args.delete(:business_process_ids)
          if policy&.policy_business_processes&.present? && (policy&.policy_business_processes.where(draft_id: nil).present? || policy&.policy_business_processes.where.not(draft_id: nil).present?)
            policy.policy_business_processes.each do |pb|
              if pb&.draft_id.present?
                prev_buspro.push(pb&.id)
              end
            end
          end
        end
        if args[:reference_ids].present?
          reference = args[:reference_ids]
          args.delete(:reference_ids)
          if policy&.policy_references&.present? && (policy&.policy_references.where(draft_id: nil).present? || policy&.policy_references.where.not(draft_id: nil).present?)
            policy.policy_references.each do |pb|
              if pb&.draft_id.present?
                prev_reference.push(pb&.id)
              end
            end
          end
        end
        if args[:resource_ids].present?
          resource = args[:resource_ids]
          args.delete(:resource_ids)
          if policy&.policy_resources&.present? && (policy&.policy_resources.where(draft_id: nil).present? || policy&.policy_resources.where.not(draft_id: nil).present?)
            policy.policy_resources.each do |pb|
              if pb&.draft_id.present?
                prev_resource.push(pb&.id)
              end
            end
          end
        end
        if args[:risk_ids].present?
          risk = args[:risk_ids]
          args.delete(:risk_ids)
          if policy&.policy_risks&.present? && (policy&.policy_risks.where(draft_id: nil).present? || policy&.policy_risks.where.not(draft_id: nil).present?)
            policy.policy_risks.each do |pb|
              if pb&.draft_id.present?
                prev_risk.push(pb&.id)
              end
            end
          end
        end
        if args[:control_ids].present?
          control = args[:control_ids]
          args.delete(:control_ids)
          if policy&.policy_controls&.present? && (policy&.policy_controls.where(draft_id: nil).present? || policy&.policy_controls.where.not(draft_id: nil).present?)
            policy.policy_controls.each do |pb|
              if pb&.draft_id.present?
                prev_control.push(pb&.id)
              end
            end
          end
        end
        if policy.draft? == false
          policy.attributes = args
          policy.save_draft
          if policy.draft.event == "update"
            pre_pol = policy.draft.changeset.map {|x,y| Hash[x, y[0]]}
            pre_pol.map {|x| policy.update(x)}
          end
        end
        if buspro.present?
          buspro.each do |bus|
            pol_bus = PolicyBusinessProcess.new(policy_id: policy&.id, business_process_id: bus )
            pol_bus.save_draft
            if prev_buspro.present?
              polibus = PolicyBusinessProcess.where(id:prev_buspro)
              polibus.destroy_all
            end
          end 
        end
        if risk.present?
          risk.each do |ris|
            pol_ris = PolicyRisk.new(policy_id: policy&.id, risk_id: ris )
            pol_ris.save_draft
            if prev_risk.present?
              poliris = PolicyRisk.where(id:prev_risk)
              poliris.destroy_all
            end
          end 
        end
        if control.present?
          control.each do |con|
            pol_con = PolicyControl.new(policy_id: policy&.id, control_id: con )
            pol_con.save_draft
            if prev_control.present?
              policon = PolicyControl.where(id:prev_control)
              policon.destroy_all
            end
          end 
        end
        if reference.present?
          reference.each do |ref|
            pol_ref = PolicyReference.new(policy_id: policy&.id, reference_id: ref )
            pol_ref.save_draft
            if prev_reference.present?
              poliref = PolicyReference.where(id:prev_reference)
              poliref.destroy_all
            end
          end 
        end
        if resource.present?
          resource.each do |res|
            pol_res = PolicyResource.new(policy_id: policy&.id, resource_id: res )
            pol_res.save_draft
            if prev_resource.present?
              polires = PolicyResource.where(id:prev_resource)
              polires.destroy_all
            end
          end 
        end
        policy.draft.update_attributes(
          object_changes: JSON.parse(policy.draft.object_changes).update(args.stringify_keys!).to_json, 
          object:JSON.parse(policy.draft.object).update(args.stringify_keys!).to_json
        )
        if policy.published_at.nil?
          policy.draft.reify.update(args)
        end
        policy.update(status:"draft")


      else
        raise GraphQL::ExecutionError, "You cannot edit this draft. This Draft belongs to another User"
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
    def ready?(args)
      authorize_user
    end
  end
end
