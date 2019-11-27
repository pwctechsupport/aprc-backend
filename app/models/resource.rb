class Resource < ApplicationRecord
  has_many :policy_resources
  has_many :policies, through: :policy_resources
end
