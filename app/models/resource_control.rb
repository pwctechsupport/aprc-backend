class ResourceControl < ApplicationRecord
  has_paper_trail on: []

  # Add callbacks in the order you need.
  paper_trail.on_destroy    # add destroy callback
  paper_trail.on_update     # etc.
  paper_trail.on_create
  paper_trail.on_touch

  has_drafts

  
  belongs_to :resource, class_name: "Resource", foreign_key: "resource_id", optional: true
  belongs_to :control, class_name: "Control", foreign_key: "control_id", optional: true

  def to_humanize
    "#{self.control&.description}: #{self.resource.name}"
  end
end
