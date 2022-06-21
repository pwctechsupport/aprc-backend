module Types
  class UserPolicyVisitType < BaseObject
    field :id, ID, null: false
    field :user_id, ID, null: true
    field :user, Types::UserType, null: true
    field :policy_id, ID, null: true
    field :policy, Types::PolicyType, null: true
    field :recent_visit, String, null: true
  end
end