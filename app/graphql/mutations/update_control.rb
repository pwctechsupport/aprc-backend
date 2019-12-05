# frozen_string_literal: true

module Mutations
  class UpdateControl < Mutations::BaseMutation
    graphql_name "UpdateControl"

    argument :id, ID, required: true
    # argument :control_description, String, required: false
    # argument :assertion_risk, String, required: false
    argument :type_of_control, Types::Enums::TypeOfControl, required: true
    argument :frequency, Types::Enums::Frequency, required: true
    argument :nature, Types::Enums::Nature, required: true 
    argument :assertion, Types::Enums::Assertion, required: true
    argument :ipo, Types::Enums::Ipo, required: true
    argument :control_owner, String, required: false
    argument :description, String, required: false
    argument :fte_estimate, String, required: false 
    argument :business_process_ids, [ID], required: false
    argument :risk_ids, [ID], required: false

    field :control, Types::ControlType, null: true

    def resolve(id:, **args)
      control = Control.find(id)
      success = control.update_attributes(args.to_h)

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