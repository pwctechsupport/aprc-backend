module Mutations
  class UpdateControl < Mutations::BaseMutation
    graphql_name "UpdateControl"

    argument :id, ID, required: true
    argument :type_of_control, Types::Enums::TypeOfControl, required: false
    argument :frequency, Types::Enums::Frequency, required: false
    argument :nature, Types::Enums::Nature, required: false 
    argument :assertion, [Types::Enums::Assertion], required: false
    argument :activity_controls_attributes, [Types::BaseScalar], required: false
    argument :ipo, [Types::Enums::Ipo], required: false
    argument :description, String, required: false
    argument :control_owner, [ID], as: :department_ids,required: false
    argument :description, String, required: false
    argument :fte_estimate, String, required: false 
    argument :business_process_ids, [ID], required: false
    argument :risk_business_process_ids, [ID], required: false
    argument :description_ids, [ID], required: false
    argument :status, Types::Enums::Status, required: false
    argument :risk_ids, [ID], required: false
    argument :key_control, Boolean, required: false
    argument :last_updated_by, String, required: false

    field :control, Types::ControlType, null: true

    def resolve(id:, **args)
      Control.serialize(:control_owner, Array)
      current_user = context[:current_user]
      actor_control_id = []
      control = Control.find(id)
      if control&.request_edits&.last&.approved?
        if control.draft?
          raise GraphQL::ExecutionError, "Draft Cannot be created until another Draft is Approved/Rejected by an Admin"
        else
          if args[:business_process_ids].present? || args[:risk_ids].present?
            args[:is_related] = true
          end
          if args[:activity_controls_attributes].present?
            act = args[:activity_controls_attributes]
            if act&.first&.class == ActionController::Parameters
              activities = act.collect {|x| x.permit(:id,:activity,:guidance,:control_id,:resuploadBase64,:resuploadFileName,:_destroy,:resupload,:user_id,:resupload_file_name)}
              args.delete(:activity_controls_attributes)
              args[:activity_controls_attributes]= activities.collect{|x| x.to_h}
            end
            args[:activity_controls_attributes].each do |aca|
              if aca["id"].present?
                act_control = ActivityControl.find(aca["id"])
                if aca["_destroy"].present?
                  act_control.destroy
                else
                  act_control.attributes = aca
                  act_control.save_draft
                  actor_control_id.push(act_control&.id)
                end
              else
                act_control = ActivityControl.new(aca)
                act_control.save_draft
                actor_control_id.push(act_control&.id)
              end
            end
            args.delete(:activity_controls_attributes)
          end
          if args[:department_ids].present?
            args[:control_owner] = args[:department_ids].map{|x| Department.find(x&.to_i).name}
          end
          args[:last_updated_by] = current_user.name
          prev_riskbuspro = []
          prev_buspro = []
          prev_risk = []

          if args[:risk_business_process_ids].present?
            riskbuspro = args[:risk_business_process_ids]
            args.delete(:risk_business_process_ids)
            if control&.control_risk_business_processes&.present? && (control&.control_risk_business_processes.where(draft_id: nil).present? || control&.control_risk_business_processes.where.not(draft_id: nil).present?)
              control.control_risk_business_processes.each do |pb|
                if pb&.draft_id.present?
                  prev_riskbuspro.push(pb&.id)
                end
              end
            end
          end

          if args[:business_process_ids].present?
            buspro = args[:business_process_ids]
            args.delete(:business_process_ids)
            if control&.control_business_processes&.present? && (control&.control_business_processes.where(draft_id: nil).present? || control&.control_business_processes.where.not(draft_id: nil).present?)
              control.control_business_processes.each do |pb|
                if pb&.draft_id.present?
                  prev_buspro.push(pb&.id)
                end
              end
            end
          end
          if args[:risk_ids].present?
            risk = args[:risk_ids]
            args.delete(:risk_ids)
            if control&.control_risks&.present? && (control&.control_risks.where(draft_id: nil).present? || control&.control_risks.where.not(draft_id: nil).present?)
              control.control_risks.each do |pb|
                if pb&.draft_id.present?
                  prev_risk.push(pb&.id)
                end
              end
            end
          end
          control&.attributes = args
          control&.save_draft
          if actor_control_id.count != 0
            actor_control_id.map{|x| ActivityControl.find(x).update(control_id: control&.id)}
          end
          if control&.draft_id.present?
            if control.draft.event == "update"
              if args[:control_owner].present? || args[:ipo].present? || args[:assertion].present?
                serial = ["control_owner", "assertion", "ipo"]
                serial.each do |sif|
                  if control.draft.changeset[sif].present?
                    control.draft.changeset[sif].map!{|x| JSON.parse(x)}
                  end
                end
              end
              pre_con = control.draft.changeset.map {|x,y| Hash[x, y[0]]}
              pre_con.map {|x| control.update(x)}
            end
          end
          if riskbuspro.present?
            riskbuspro.each do |riskbus|
              riskcon_bus = ControlRiskBusinessProcess.new(control_id: control&.id, risk_business_process_id: riskbus )
              riskcon_bus.save_draft
              if prev_riskbuspro.present?
                riskcontbus = ControlRiskBusinessProcess.where(id:prev_riskbuspro)
                riskcontbus.destroy_all
              end
            end 
          end
          if buspro.present?
            buspro.each do |bus|
              con_bus = ControlBusinessProcess.new(control_id: control&.id, business_process_id: bus )
              con_bus.save_draft
              if prev_buspro.present?
                contbus = ControlBusinessProcess.where(id:prev_buspro)
                contbus.destroy_all
              end
            end 
          end
          if risk.present?
            risk.each do |ris|
              con_ris = ControlRisk.new(control_id: control&.id, risk_id: ris )
              con_ris.save_draft
              if prev_risk.present?
                contris = ControlRisk.where(id:prev_risk)
                contris.destroy_all
              end
            end 
          end
          admin = User.with_role(:admin_reviewer).pluck(:id)
          if control.draft.present?
            control.update(status:"waiting_for_review")
            Notification.send_notification(admin, control&.description, control&.type_of_control,control, current_user&.id, "request_draft")
          end
        end
      else
        raise GraphQL::ExecutionError, "Request not granted. Please Check Your Request Status"
      end

      MutationResult.call(
        obj: { control: control },
        success: control.persisted?,
        errors: control.errors
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


