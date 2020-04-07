class ControlBusinessProcess < ApplicationRecord
  has_paper_trail on: []

  # Add callbacks in the order you need.
  paper_trail.on_destroy    # add destroy callback
  paper_trail.on_update     # etc.
  paper_trail.on_create
  paper_trail.on_touch
  
  belongs_to :control, optional: true
  belongs_to :business_process, optional: true
  def to_humanize
    "#{self.control.control_owner.join(", ")} : #{self.business_processes&.collect{|x| x.name}.join(", ")}"
  end
end
