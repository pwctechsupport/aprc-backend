module Types
	class PolicyReferenceType < BaseObject
		field :id, ID, null: false
		field :policy_id, ID, null: true
		field :reference_id, ID, null: true
		field :policy, Types::PolicyType, null: true
		field :reference, Types::ReferenceType, null: true
		field :created_at, GraphQL::Types::ISO8601DateTime, null: false
		field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :draft, Types::VersionType, null: true
	end
end