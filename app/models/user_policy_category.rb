class UserPolicyCategory < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :policy_category, optional: true
end
