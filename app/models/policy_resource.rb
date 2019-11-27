class PolicyResource < ApplicationRecord
  belongs_to :policy
  belongs_to :resource
end
