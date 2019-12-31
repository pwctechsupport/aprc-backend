module Types
  class BookmarkRiskType < BaseObject
    field :id, ID, null: false
    field :risk_id, ID, null: false
    field :user_id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :risk, Types::RiskType, null: true 
    field :user, Types::UserType, null:true
  end
end
