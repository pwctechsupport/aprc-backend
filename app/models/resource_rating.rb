class ResourceRating < ApplicationRecord
  has_paper_trail on: []

  # Add callbacks in the order you need.
  paper_trail.on_destroy    # add destroy callback
  paper_trail.on_update     # etc.
  paper_trail.on_create
  paper_trail.on_touch
  
  belongs_to :resource, optional: true
  belongs_to :user, optional: true

  def to_humanize
    "#{self.user.name} rate #{self.resource.name} #{self.rating}"
  end
end
