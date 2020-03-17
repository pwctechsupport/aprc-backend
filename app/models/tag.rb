class Tag < ApplicationRecord
  has_paper_trail on: []

  # Add callbacks in the order you need.
  paper_trail.on_destroy    # add destroy callback
  paper_trail.on_update     # etc.
  paper_trail.on_create
  paper_trail.on_touch
  has_drafts
  
  belongs_to :resource, optional: true
  belongs_to :business_process, optional: true
  belongs_to :user, optional: true
  belongs_to :control, optional: true
  belongs_to :risk, optional:true
end
