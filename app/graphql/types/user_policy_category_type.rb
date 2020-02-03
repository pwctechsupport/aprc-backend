module Types
  class UserPolicyCategoryType < BaseObject
    field :id, ID, null: false
    field :userId, ID, null: false
    field :user, Types::UserType, null: true
    field :policyCategoryId, ID, null: true
  end
end
