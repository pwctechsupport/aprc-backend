class PolicyBusinessProcess < ApplicationRecord
  belongs_to :policy
  belongs_to :business_process
end
