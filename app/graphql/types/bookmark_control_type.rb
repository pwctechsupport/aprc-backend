module Types
  class BookmarkControlType < BaseObject
    field :id, ID, null: false
    field :control_id, ID, null: false
    field :user_id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :control, Types::ControlType, null: true 
    field :user, Types::UserType, null:true

  end
end
