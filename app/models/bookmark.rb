class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :originator, polymorphic: true
end
