module Mutations
  class CreatePolicyCategory < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :name, String, required: true


    # return type from the mutation
    field :policy_category, Types::PolicyCategoryType, null: true

    def resolve(name: nil)
      policy_category = PolicyCategory.create!(
        name: name
      )
      {policy_category: policy_category}
    end
  end
end