module Types
	class PolicyControlType < BaseObject
		field :id, ID, null: false
		field :policy_id, ID, null: true
		field :control_id, ID, null: true
		field :policy, Types::PolicyType, null: true
		field :control, Types::ControlType, null: true
		field :created_at, GraphQL::Types::ISO8601DateTime, null: false
		field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :draft, Types::VersionType, null: true
	end
end