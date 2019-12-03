module Mutations
  class CreateRisk < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true


    # return type from the mutation
    field :risk, Types::RiskType, null: true

    def resolve(name: nil)
      risk = Risk.create!(
        name: name
      )
      {risk: risk}
    end
  end
end