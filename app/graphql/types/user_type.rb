module Types
  class UserType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :firstName, String, null: false
    field :lastName, String, null: false
    field :email, String, null: true
    field :token, String, null: false
    field :phone, String, null: true
    field :policies, [Types::PolicyType], null: false
    field :policy_category, Types::PolicyCategoryType, null: true do
      argument :id, ID, required: true
    end
    # field :controls, [Types::ControlType], null: true
    # field :risks, [Types::RiskType], null: true
    # field :references, [Types::ReferenceType], null: true
    # field :business_processes, [Types::BusinessProcessType], null: true
    # field :resources, [Types::ResourceType], null: true


    def policies
      current_user = context[:current_user]
      current_user.policies
    end

    def policy_category(id:)
      current_user = context[:current_user]
      current_user.policies.find_by(id:id).policy_category
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