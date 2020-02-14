class PolicyCategory < ApplicationRecord
  has_paper_trail on: []
  include DeeplyPublishable
  has_drafts
  # Add callbacks in the order you need.
  paper_trail.on_destroy    # add destroy callback
  paper_trail.on_update     # etc.
  paper_trail.on_create
	paper_trail.on_touch
	
	validates :name, uniqueness: true
  has_many :policies, inverse_of: :policy_category
  accepts_nested_attributes_for :policies, allow_destroy: true
  has_many :user_policy_categories, dependent: :destroy
  has_many :users, through: :user_policy_categories
  def to_humanize
    "#{self.name}"
  end
end
