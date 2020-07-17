class PolicyResource < ApplicationRecord
  # has_paper_trail on: []

  # # Add callbacks in the order you need.
  # paper_trail.on_destroy    # add destroy callback
  # paper_trail.on_update     # etc.
  # paper_trail.on_create
  # paper_trail.on_touch

  has_drafts
  
  belongs_to :policy, class_name: "Policy", foreign_key: "policy_id", optional: true
  belongs_to :resource, class_name: "Resource", foreign_key: "resource_id", optional: true
  def to_humanize
    "#{self.policy.title} : #{self.resource.name}"
  end
end