module Types
	class ResourceControlType < BaseObject
		field :id, ID, null: false
		field :resource_id, ID, null: true
		field :control_id, ID, null: true
		field :resource, Types::ResourceType, null: true
		field :control, Types::ControlType, null: true
		field :created_at, GraphQL::Types::ISO8601DateTime, null: false
		field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
	end
end