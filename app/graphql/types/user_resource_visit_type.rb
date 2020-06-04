module Types
  class UserResourceVisitType < BaseObject
    field :id, ID, null: false
    field :user_id, ID, null: true
    field :user, Types::UserType, null: true
    field :resource_id, ID, null: true
    field :resource, Types::ResourceType, null: true
    field :recent_visit, String, null: true
  end
end