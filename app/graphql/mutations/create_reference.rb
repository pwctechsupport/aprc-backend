module Mutations
  class CreateReference < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true


    # return type from the mutation
    field :reference, Types::ReferenceType, null: true

    def resolve(name: nil)
      reference = Reference.create!(
        name: name
      )
      {reference: reference}
    end
  end
end