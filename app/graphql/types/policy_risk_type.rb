module Types
	class PolicyRiskType < BaseObject
		field :id, ID, null: false
		field :policy_id, ID, null: true
		field :risk_id, ID, null: true
		field :policy, Types::PolicyType, null: true
		field :risk, Types::RiskType, null: true
		field :created_at, GraphQL::Types::ISO8601DateTime, null: false
		field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
	end
end