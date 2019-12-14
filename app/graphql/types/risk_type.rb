module Types
  class RiskType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :status, String, null: true
    field :level_of_risk, String, null: true
    field :business_process_id, ID, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end