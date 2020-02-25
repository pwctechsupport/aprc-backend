module Types
  class ReferenceType < BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :policies, [Types::PolicyType], null: true
    field :status, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end