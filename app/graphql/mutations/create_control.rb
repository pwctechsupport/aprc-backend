module Mutations
  class CreateControl < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :type_of_control, String, required: false
    argument :frequency, String, required: false
    argument :nature, String, required: false 
    argument :assertion, String, required: false
    argument :ipo, String, required: false
    argument :control_owner, String, required: false
    argument :fte_estimate, Int, required: false 

    # return type from the mutation
    field :control, Types::ControlType, null: true

    def resolve(control_description: nil, assertion_risk: nil, type_of_control: nil, nature: nil, assertion: nil, ipo: nil, control_owner: nil, fte_estimate: nil, frequency: nil)
      control = Control.create!(
      type_of_control: type_of_control,
      nature: nature,
      assertion: assertion,
      ipo: ipo,
      control_owner: control_owner,
      fte_estimate: fte_estimate
      )
      {control: control}
    end
    # def ready?(args)
    #   authorize_user
    # end
  end
end