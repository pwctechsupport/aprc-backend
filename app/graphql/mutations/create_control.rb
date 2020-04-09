module Mutations
  class CreateControl < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    # argument :type_of_control, String, required: false
    # argument :frequency, String, required: false
    # argument :nature, String, required: false 
    # argument :assertion, String, required: false
    # argument :ipo, String, required: false
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

    # return type from the mutation
    field :control, Types::ControlType, null: true
    

    def resolve(args)
      current_user = context[:current_user]
      if args[:activity_controls_attributes].present?
        act = args[:activity_controls_attributes]
        if act&.first&.class == ActionController::Parameters
          activities = act.collect {|x| x.permit(:id,:activity,:guidance,:control_id,:resuploadBase64,:resuploadFileName,:_destroy,:resupload,:user_id,:resupload_file_name)}
          args.delete(:activity_controls_attributes)
          args[:activity_controls_attributes]= activities.collect{|x| x.to_h}
          args[:created_by] = current_user&.name || "User with ID#{current_user&.id}"
          args[:last_updated_by] = current_user&.name || "User with ID#{current_user&.id}"
          if args[:department_ids].present?
            args[:control_owner] = args[:department_ids].map{|x| Department.find(x&.to_i).name}
          end
          control=Control.new(args)
          control&.save_draft
          admin = User.with_role(:admin_reviewer).pluck(:id)
          if control.id.present?
            Notification.send_notification(admin, control&.description, control&.type_of_control,control, current_user&.id, "request_draft")
          else
            raise GraphQL::ExecutionError, "The exact same draft cannot be duplicated"
          end
        else
          if args[:department_ids].present?
            args[:control_owner] = args[:department_ids].map{|x| Department.find(x&.to_i).name}
          end
          control=Control.new(args)
          control&.save_draft

          admin = User.with_role(:admin_reviewer).pluck(:id)
          if control.id.present?
            Notification.send_notification(admin, control&.description, control&.type_of_control,control, current_user&.id, "request_draft")
          else
            raise GraphQL::ExecutionError, "The exact same draft cannot be duplicated"
          end
        end
      else
        if args[:department_ids].present?
          args[:control_owner] = args[:department_ids].map{|x| Department.find(x&.to_i).name}
        end
        control=Control.new(args)

        control.save_draft

        admin = User.with_role(:admin_reviewer).pluck(:id)
        if control.id.present?
          Notification.send_notification(admin, control&.description, control&.type_of_control,control, current_user&.id, "request_draft")
        else
          raise GraphQL::ExecutionError, "The exact same draft cannot be duplicated"
        end
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