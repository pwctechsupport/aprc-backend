class ResourceRating < ApplicationRecord
  belongs_to :resource, optional: true
  belongs_to :user, optional: true
end
