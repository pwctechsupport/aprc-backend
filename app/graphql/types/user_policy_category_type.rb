module Types
  class UserPolicyCategoryType < BaseObject
    field :id, ID, null: false
    field :user_id, ID, null: false
    field :user, Types::UserType, null: true
    field :policy_category_ids, [ID], null: true
    field :policy_categories, [Types::PolicyCategoryType], null: true
  end
end
