module Types
  class PolicyCategoryType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :policies, [Types::PolicyType], null: false
    field :users, [Types::UserType], null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :draft, Types::VersionType, null: true
    field :user_reviewer_id, ID, null: true
    field :user_reviewer, Types::UserType, null: true
  end
end