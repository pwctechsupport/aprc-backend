class ControlRisk < ApplicationRecord
  has_paper_trail on: []

  # Add callbacks in the order you need.
  paper_trail.on_destroy    # add destroy callback
  paper_trail.on_update     # etc.
  paper_trail.on_create
  paper_trail.on_touch
  
  belongs_to :control, optional: true
  belongs_to :risk, class_name: "Risk", foreign_key: "risk_id", optional: true
  def to_humanize
    "#{self.control.control_owner} : #{self.risk.name}"
  end
end
