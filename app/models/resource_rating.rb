class ResourceRating < ApplicationRecord
  belongs_to :resource
  belongs_to :user
end
