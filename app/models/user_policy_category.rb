class UserPolicyCategory < ApplicationRecord
  include DeeplyPublishable
  has_drafts
  validates :user_id, :uniqueness => {:scope => :policy_category_id}
  belongs_to :user, optional: true
  belongs_to :policy_category, optional: true

end
