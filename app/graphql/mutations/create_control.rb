module Mutations
  class CreateControl < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    # argument :type_of_control, String, required: false
    # argument :frequency, String, required: false
    # argument :nature, String, required: false 
    # argument :assertion, String, required: false
    # argument :ipo, String, required: false
    argument :control_owner, String, required: false
    argument :fte_estimate, Int, required: false 
    argument :type_of_control, Types::Enums::TypeOfControl, required: true
    argument :frequency, Types::Enums::Frequency, required: true
    argument :nature, Types::Enums::Nature, required: true 
    argument :assertion, Types::Enums::Assertion, required: true
    argument :ipo, Types::Enums::Ipo, required: true
    argument :business_process_ids, [ID], required: false
    argument :description_ids, [ID], required: false
    argument :status, Types::Enums::Status, required: true
    argument :risk_ids, [ID], required: false

    # return type from the mutation
    field :control, Types::ControlType, null: true

    def resolve(args)
      control = Control.create!(args.to_h)

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