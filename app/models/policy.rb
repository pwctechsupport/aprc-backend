class Policy < ApplicationRecord
  belongs_to :policy_category
  belongs_to :user, optional: true
end