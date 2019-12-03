module Mutations
  class CreateDescription < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true


    # return type from the mutation
    field :description, Types::DescriptionType, null: true

    def resolve(name: nil)
      description = Description.create!(
        name: name
      )
      {description: description}
    end
  end
end