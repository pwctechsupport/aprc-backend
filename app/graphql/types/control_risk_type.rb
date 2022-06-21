module Types
	class ControlRiskType < BaseObject
		field :id, ID, null: false
		field :risk_id, ID, null: true
		field :control_id, ID, null: true
		field :risk, Types::RiskType, null: true
		field :control, Types::ControlType, null: true
		field :created_at, GraphQL::Types::ISO8601DateTime, null: false
		field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
	end
end