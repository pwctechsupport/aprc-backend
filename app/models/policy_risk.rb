class PolicyRisk < ApplicationRecord
  has_paper_trail on: []

  # Add callbacks in the order you need.
  paper_trail.on_destroy    # add destroy callback
  paper_trail.on_update     # etc.
  paper_trail.on_create
  paper_trail.on_touch
  
  has_drafts

  belongs_to :policy
  belongs_to :risk
  def to_humanize
    "#{self.policy.title} : #{self.risk.name}"
  end
end
