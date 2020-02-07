class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :originator, polymorphic: true
  validates :user_id, :uniqueness => {:scope => [:originator_type, :originator_id]}
end
