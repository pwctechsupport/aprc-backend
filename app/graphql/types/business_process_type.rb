module Types
  class BusinessProcessType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :ancestry, ID, null: true
    field :parent_id, ID, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end