class BookmarkPolicy < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :policy, optional: true
end
