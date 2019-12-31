class BookmarkRisk < ApplicationRecord
  belongs_to :user
  belongs_to :risk
end
