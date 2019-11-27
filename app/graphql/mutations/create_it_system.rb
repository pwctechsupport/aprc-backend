module Mutations
  class CreateItSystem < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true


    # return type from the mutation
    field :ItSystem, Types::ItSystemType, null: true

    def resolve(name: nil)
      it_system = ItSystem.create!(
        name: name
      )
      {it_system: it_system}
    end
  end
end