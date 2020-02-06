module Types
  class BookmarkType < BaseObject
    field :id, ID, null: false
    field :user_id, ID, null: true
    field :originator_type, String, null: true
    field :originator_id, ID, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :name, String, null:true
    field :originator, Types::OriginatorType, null: true
    field :user, Types::UserType, null: true
  end
end
