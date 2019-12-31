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
    argument :description, String, required: false
    argument :type_of_control, Types::Enums::TypeOfControl, required: false
    argument :frequency, Types::Enums::Frequency, required: false
    argument :nature, Types::Enums::Nature, required: false 
    argument :assertion, [Types::Enums::Assertion], required: false
    argument :ipo, [Types::Enums::Ipo], required: false
    argument :business_process_ids, [ID], required: false
    argument :description_ids, [ID], required: false
    argument :status, Types::Enums::Status, required: false
    argument :risk_ids, [ID], required: false

    # return type from the mutation
    field :control, Types::ControlType, null: true

    def resolve(args)
      control = Control.find_by(description: args[:description])
      if control.present?
        control.update_attributes(args.to_h)
      else
        control=Control.create!(args.to_h)
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