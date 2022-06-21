module Types
	class ControlBusinessProcessType < BaseObject
		field :id, ID, null: false
		field :business_process_id, ID, null: true
		field :control_id, ID, null: true
		field :business_process, Types::BusinessProcessType, null: true
		field :control, Types::ControlType, null: true
		field :created_at, GraphQL::Types::ISO8601DateTime, null: false
		field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
	end
end