module Types
	class PolicyResourceType < BaseObject
		field :id, ID, null: false
		field :policy_id, ID, null: true
		field :resource_id, ID, null: true
		field :policy, Types::PolicyType, null: true
		field :resource, Types::ResourceType, null: true
		field :created_at, GraphQL::Types::ISO8601DateTime, null: false
		field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
	end
end