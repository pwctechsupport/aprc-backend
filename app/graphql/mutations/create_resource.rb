module Mutations
  class CreateResource < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true


    # return type from the mutation
    field :resource, Types::ResourceType, null: true

    def resolve(name: nil)
      resource = Resource.create!(
        name: name
      )
      {resource: resource}
    end
  end
end