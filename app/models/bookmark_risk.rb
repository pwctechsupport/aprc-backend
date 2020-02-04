class BookmarkRisk < ApplicationRecord
  has_paper_trail on: []

  # Add callbacks in the order you need.
  paper_trail.on_destroy    # add destroy callback
  paper_trail.on_update     # etc.
  paper_trail.on_create
  paper_trail.on_touch
  
  belongs_to :user
  belongs_to :risk
  def to_humanize
    "#{self.user.name} Bookmarked #{self.risk.name}"
  end
end
