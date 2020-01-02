module Types
  class BookmarkBusinessProcessType < BaseObject
    field :id, ID, null: false
    field :business_process_id, ID, null: false
    field :user_id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :business_process, Types::BusinessProcessType, null: true 
    field :user, Types::UserType, null:true
  end
end
