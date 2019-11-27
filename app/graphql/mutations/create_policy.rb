module Mutations
  class CreatePolicy < Mutations::BaseMutation
    # arguments passed to the `resolved` method
    argument :title, String, required: true
    argument :description, String, required: true
    argument :policy_category_id, ID, required: true 

    # return type from the mutation
    field :policy, Types::PolicyType, null: true

    def resolve(title: nil, description: nil, policy_category_id: nil, user_id: nil)
      policy = Policy.create!(title: title,description: description,
      policy_category_id: policy_category_id,
      user_id: context[:current_user].id
      )
      {policy: policy}
    end
    def ready?(args)
      authorize_user
    end
  end
end