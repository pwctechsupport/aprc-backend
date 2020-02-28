module Mutations
  class CreateControl < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    # argument :type_of_control, String, required: false
    # argument :frequency, String, required: false
    # argument :nature, String, required: false 
    # argument :assertion, String, required: false
    # argument :ipo, String, required: false
    argument :control_owner, String, required: false
    argument :description, String, required: false
    argument :fte_estimate, Int, required: false 
    argument :description, String, required: false
    argument :type_of_control, Types::Enums::TypeOfControl, required: false
    argument :activity_controls_attributes, [Types::BaseScalar], required: false
    argument :frequency, Types::Enums::Frequency, required: false
    argument :nature, Types::Enums::Nature, required: false 
    argument :assertion, [Types::Enums::Assertion], required: false
    argument :ipo, [Types::Enums::Ipo], required: false
    argument :business_process_ids, [ID], required: false
    argument :description_ids, [ID], required: false
    argument :status, Types::Enums::Status, required: false
    argument :risk_ids, [ID], required: false
    argument :key_control, Boolean, required: false

    # return type from the mutation
    field :control, Types::ControlType, null: true
    

    def resolve(args)
      current_user = context[:current_user]
      if args[:activity_controls_attributes].present?
        act = args[:activity_controls_attributes]&.first

        if act&.class == ActionController::Parameters
          act_control = act&.permit(:id,:activity,:guidance,:control_id,:resuploadBase64,:resuploadFileName,:_destroy)
          args.delete(:activity_controls_attributes)
          args[:activity_controls_attributes]= [act_control.to_h]

          control=Control.new(args)
          control&.save_draft

          admin = User.with_role(:admin_reviewer).pluck(:id)
          Notification.send_notification(admin, control&.description, control&.type_of_control,control, current_user&.id)
        else
          control=Control.new(args)
          control&.save_draft

          admin = User.with_role(:admin_reviewer).pluck(:id)
          Notification.send_notification(admin, control&.description, control&.type_of_control,control, current_user&.id)
        end
      else
        control=Control.new(args)

        control.save_draft

        admin = User.with_role(:admin_reviewer).pluck(:id)
        Notification.send_notification(admin, control&.description, control&.type_of_control,control, current_user&.id)
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