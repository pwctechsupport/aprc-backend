class Types::VersionType < Types::BaseObject
	description "Version of an Object"

	field :id, ID, null: true
	field :item_type, String, null: true
	field :item_id, ID, null: true
	field :event, String, null: true
	field :object, String, null: true
	field :created_at, GraphQL::Types::ISO8601DateTime, null: false
	field :object_changes, String, null: true
	field :item, Types::ItemType, null: false	
	field :user, Types::UserType, null: true
	def user
		who = object.whodunnit.to_i
		User.find(who)
	end
end

