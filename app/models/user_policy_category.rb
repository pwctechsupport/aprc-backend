class UserPolicyCategory < ApplicationRecord
  include DeeplyPublishable
  has_drafts
  belongs_to :user, optional: true
  belongs_to :policy_category, optional: true
  belongs_to :user_reviewer, class_name: "User", foreign_key:"user_reviewer_id", optional: true

end
