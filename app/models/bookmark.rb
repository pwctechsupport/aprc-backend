class Bookmark < ApplicationRecord

  # has_paper_trail on: []

  # # Add callbacks in the order you need.
  # paper_trail.on_destroy    # add destroy callback
  # paper_trail.on_update     # etc.
  # paper_trail.on_create
  # paper_trail.on_touch

  belongs_to :user
  belongs_to :originator, polymorphic: true
  validates :user_id, :uniqueness => {:scope => [:originator_type, :originator_id]}

  def to_humanize
    "#{self.user.name} Bookmarked #{self.originator_type} #{self&.name}"
  end
end
