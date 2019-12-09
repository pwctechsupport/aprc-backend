class PolicyReference < ApplicationRecord
  belongs_to :policy, optional: true
  belongs_to :reference, optional: true
end