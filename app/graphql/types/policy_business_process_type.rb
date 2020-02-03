module Types
	class PolicyBusinessProcessType < BaseObject
		field :id, ID, null: false
		field :policy_id, ID, null: true
		field :business_process_id, ID, null: true
		field :policy, Types::PolicyType, null: true
		field :business_process, Types::BusinessProcessType, null: true
		field :created_at, GraphQL::Types::ISO8601DateTime, null: false
		field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
	end
end