module Mutations
  class CreateCategory < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true


    # return type from the mutation
    field :category, Types::CategoryType, null: true

    def resolve(name: nil)
      category = Category.create!(
        name: name
      )
      {category: category}
    end
  end
end