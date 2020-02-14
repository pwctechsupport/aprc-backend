class UserPolicyCategory < ApplicationRecord
  include DeeplyPublishable
  has_drafts
  belongs_to :user, optional: true
  belongs_to :policy_category, optional: true

end
