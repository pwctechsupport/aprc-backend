class PolicyRisk < ApplicationRecord
  belongs_to :policy
  belongs_to :risk
end
