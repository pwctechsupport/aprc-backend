module Mutations
  class CreateControl < Mutations::BaseMutation
    graphql_name "CreateControl"

    argument :control_owner, [ID], as: :department_ids,required: true
    argument :fte_estimate, Int, required: false 
    argument :description, String, required: true
    argument :type_of_control, Types::Enums::TypeOfControl, required: true
    argument :activity_controls_attributes, [Types::BaseScalar], required: true
    argument :frequency, Types::Enums::Frequency, required: true
    argument :nature, Types::Enums::Nature, required: true 
    argument :assertion, [Types::Enums::Assertion], required: true
    argument :ipo, [Types::Enums::Ipo], required: true
    argument :business_process_ids, [ID], required: false
    argument :description_ids, [ID], required: false
    argument :status, Types::Enums::Status, required: false
    argument :risk_ids, [ID], required: false
    argument :key_control, Boolean, required: false
    argument :created_by, String, required: false
    argument :last_updated_by, String, required: false
    argument :department_ids, [ID], required: false

    field :control, Types::ControlType, null: true
    
    def resolve(args)
      Control.serialize(:control_owner, Array)
      current_user = context[:current_user]
      actor_control_id = []
      if args[:activity_controls_attributes].present?
        act = args[:activity_controls_attributes]
        if act&.first&.class == ActionController::Parameters
          activities = act.collect {|x| x.permit(:id,:activity,:guidance,:control_id,:resuploadBase64,:resuploadFileName,:_destroy,:resupload,:user_id,:resupload_file_name)}
          args.delete(:activity_controls_attributes)
          safe_array = []
          activities.each do |x| 
            safe_hash= {}
            x.to_h.each{|k,v| safe_hash[k.html_safe]= v.html_safe}
            safe_array.push(safe_hash)
          end
          args[:activity_controls_attributes] = safe_array
        end
        args[:activity_controls_attributes].each do |aca|
          act_control = ActivityControl.new(aca)
          act_control.save_draft
          actor_control_id.push(act_control&.id)
        end
        args.delete(:activity_controls_attributes)
      end
      args[:created_by] = current_user.name
      args[:last_updated_by] = current_user.name 
      if args[:department_ids].present?
        department_ids = args[:department_ids].map(&:html_safe)
        args[:control_owner] = department_ids.map{|x| Department.find(x).name}.map(&:html_safe)
      end
      if args[:business_process_ids].present?
        buspro = args[:business_process_ids]
        args.delete(:business_process_ids)
      end
      if args[:risk_ids].present?
        risk = args[:risk_ids]
        args.delete(:risk_ids)
      end
      control=Control.new(args)
      control&.save_draft
      if actor_control_id.count != 0
        actor_control_id.map{|x| ActivityControl.find(x).update(control_id: control&.id)}
      end
      admin = User.with_role(:admin_reviewer).pluck(:id)
      if control.id.present?
        if buspro.present?
          buspro.each do |bus|
            con_bus = ControlBusinessProcess.new(control_id: control&.id, business_process_id: bus )
            con_bus.save_draft
          end 
        end
        if risk.present?
          risk.each do |ris|
            con_ris = ControlRisk.new(control_id: control&.id, risk_id: ris )
            con_ris.save_draft
          end 
        end
        Notification.send_notification(admin, control&.description, control&.type_of_control,control, current_user&.id, "request_draft")
        control.update(status: "waiting_for_review" )
      else
        raise GraphQL::ExecutionError, "The exact same draft cannot be duplicated"
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