module Types
	class NotificationType < BaseObject
		field :id, ID, null: true
		field :title, String, null: true
		field :body, String, null: true
		field :originator_type, String, null: true
		field :originator_id, ID, null: true
		field :originator, Types::OriginatorType, null: true
		field :created_at, GraphQL::Types::ISO8601DateTime, null: false
		field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
		field :data, String, null: true
		field :is_read, Boolean, null:true
	end
end