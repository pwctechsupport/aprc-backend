module Mutations
  class CreateSubPolicy < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :title, String, required: true
    argument :description, String, required: true
    argument :parent_id, ID, required: true


    # return type from the mutation
    field :policy, Types::PolicyType, null: true

    def resolve(parent_id:, title: nil, description: nil)
      policy = Policy.create!(
        title: title,
        description: description,
        parent: Policy.find(parent_id),
        user_id: context[:current_user].id
      )
      {policy: policy}
    end
  end
end