module Types
  class RiskBusinessProcessType < BaseObject
    field :id, ID, null: false
    field :business_process_id, ID, null: false
    field :risk_id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :business_process, Types::BusinessProcessType, null: true 
    field :risk, Types::RiskType, null: true 
  end
end
