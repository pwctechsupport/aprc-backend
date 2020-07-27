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
		field :user_id, ID, null:true
		field :user, Types::UserType, null: true
		field :sender_user_id, ID, null: true
		field :sender_user, Types::UserType, null:true
		field :data_type, String, null: true
		field :sender_user_actual_name, String, null: true

		def sender_user_actual_name
			sender = object&.sender_user&.name
			if object&.is_general
				sender= "System"
				sender
			else
				sender
			end
		end
	end

end