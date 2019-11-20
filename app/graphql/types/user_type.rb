module Types
  class UserType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :firstName, String, null: false
    field :lastName, String, null: false
    field :email, String, null: true
    field :token, String, null: false
    field :phone, String, null: false
    field :policies, [Types::PolicyType], null: false

    def policies
      current_user = context[:current_user]
      current_user.policies
    end

    field :policy, Types::PolicyType, null: true do
      argument :id, ID, required: true
    end
    
    def policy(id:)
      current_user =context[:current_user]
      current_user.policies.find_by(id:id)
    end
  end
end