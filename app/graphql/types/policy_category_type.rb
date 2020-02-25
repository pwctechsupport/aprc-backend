module Types
  class PolicyCategoryType < BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :policies, [Types::PolicyType], null: true
    field :users, [Types::UserType], null: true
    field :created_at, String, null: false
    field :updated_at, String, null: false
    field :draft, Types::VersionType, null: true
    field :user_reviewer_id, ID, null: true
    field :user_reviewer, Types::UserType, null: true
  end
end