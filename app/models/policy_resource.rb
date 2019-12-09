class PolicyResource < ApplicationRecord
  belongs_to :policy, optional: true
  belongs_to :resource, optional: true
end
