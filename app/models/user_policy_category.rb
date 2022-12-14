class UserPolicyCategory < ApplicationRecord
  # has_paper_trail on: []

  # # Add callbacks in the order you need.
  # paper_trail.on_destroy    # add destroy callback
  # paper_trail.on_update     # etc.
  # paper_trail.on_create
  # paper_trail.on_touch

  has_paper_trail ignore: [:published_at, :draft_id]
  has_drafts


  belongs_to :user, optional: true
  belongs_to :policy_category, optional: true
  def to_humanize
    "#{self.user&.name} : #{self.policy_category&.name}"
  end
end
