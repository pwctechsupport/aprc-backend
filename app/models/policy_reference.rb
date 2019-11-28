class PolicyReference < ApplicationRecord
  belongs_to :policy
  belongs_to :reference
end