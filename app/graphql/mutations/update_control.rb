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
    argument :ipo, [Types::Enums::Ipo], required: false
    argument :description, String, required: false
    argument :control_owner, String, required: false
    argument :description, String, required: false
    argument :fte_estimate, String, required: false 
    argument :business_process_ids, [ID], required: false
    argument :description_ids, [ID], required: false
    argument :status, Types::Enums::Status, required: false
    argument :risk_ids, [ID], required: false
    argument :key_control, Boolean, required: false

    field :control, Types::ControlType, null: true

    def resolve(id:, **args)
      current_user = context[:current_user]
      control = Control.find(id)
      if control.draft?
        raise GraphQL::ExecutionError, "Draft Cannot be created until another Draft is Approved/Rejected by an Admin"
      else
        control.attributes = args
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