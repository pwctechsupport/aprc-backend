module Types
  class UserType < BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :firstName, String, null: false
    field :lastName, String, null: false
    field :email, String, null: true
    field :token, String, null: false
    field :phone, String, null: true
    field :role, [Int], null: true
    field :department, String, null: true
    field :jobPosition, String, null: true
    field :policies, [Types::PolicyType], null: false
    field :policy_categories, [Types::PolicyCategoryType], null: true 
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :bookmark_policies_user, [Types::BookmarkPolicyType], null: false
    field :resource_ratings, [Types::ResourceRatingType], null: false
    field :risks, [Types::RiskType], null: false
    field :bookmark_risks_user, [Types::BookmarkRiskType], null: false
    field :controls, [Types::ControlType], null: false
    field :bookmark_controls_user, [Types::BookmarkControlType], null: false
    field :roles, [Types::RoleType], null: true
    field :draft, Types::VersionType, null: true
    field :user_reviewer_id, ID, null: true
    field :user_reviewer, Types::UserType, null: true
    # field :controls, [Types::ControlType], null: true
    # field :risks, [Types::RiskType], null: true
    # field :references, [Types::ReferenceType], null: true
    # field :business_processes, [Types::BusinessProcessType], null: true
    # field :resources, [Types::ResourceType], null: true
    def bookmark_policies_user
      bookmark = object.bookmark_policies
    end

    def bookmark_risks_user
      bookmark = object.bookmark_risks
    end

    def bookmark_controls_user
      bookmark = object.bookmark_controls
    end

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