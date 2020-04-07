# frozen_string_literal: true

module Mutations
  class UpdateControl < Mutations::BaseMutation
    graphql_name "UpdateControl"

    argument :id, ID, required: true
    # argument :control_description, String, required: false
    # argument :assertion_risk, String, required: false
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
    argument :description_ids, [ID], required: false
    argument :status, Types::Enums::Status, required: false
    argument :risk_ids, [ID], required: false
    argument :key_control, Boolean, required: false
    argument :last_updated_by, String, required: false

    

    field :control, Types::ControlType, null: true

    def resolve(id:, **args)
      current_user = context[:current_user]
      control = Control.find(id)
      if control&.request_edits&.last&.approved?
        
        if control.draft?
          raise GraphQL::ExecutionError, "Draft Cannot be created until another Draft is Approved/Rejected by an Admin"
        else
          if args[:activity_controls_attributes].present?
            act = args[:activity_controls_attributes]
            if act&.first&.class == ActionController::Parameters
              activities = act.collect {|x| x.permit(:id,:activity,:guidance,:control_id,:resuploadBase64,:resuploadFileName,:_destroy,:resupload,:user_id,:resupload_file_name)}
              
              args.delete(:activity_controls_attributes)
              args[:activity_controls_attributes]= activities.collect{|x| x.to_h}
              args[:last_updated_by] = current_user&.name || "User with ID#{current_user&.id}"
              if args[:department_ids].present?
                args[:control_owner] = args[:department_ids].map{|x| Department.find(x&.to_i).name}
              end
              control&.attributes = args
              control&.save_draft
              admin = User.with_role(:admin_reviewer).pluck(:id)
              if control.draft.present?
                Notification.send_notification(admin, control&.description, control&.type_of_control,control, current_user&.id, "request_draft")
              end
            else
              if args[:department_ids].present?
                args[:control_owner] = args[:department_ids].map{|x| Department.find(x&.to_i).name}
              end
              control&.attributes = args
              control&.save_draft
              admin = User.with_role(:admin_reviewer).pluck(:id)
              if control.draft.present?
                Notification.send_notification(admin, control&.description, control&.type_of_control,control, current_user&.id, "request_draft")
              end
            end
          else
            if args[:department_ids].present?
              args[:control_owner] = args[:department_ids].map{|x| Department.find(x&.to_i).name}
            end
            control&.attributes = args
            control&.save_draft
            admin = User.with_role(:admin_reviewer).pluck(:id)
            if control.draft.present?
              Notification.send_notification(admin, control&.description, control&.type_of_control,control, current_user&.id, "request_draft")
            else
            end
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
    # def ready?(args)
    #   authorize_user
    # end
  end
end