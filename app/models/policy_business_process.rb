class PolicyBusinessProcess < ApplicationRecord
  belongs_to :policy, optional: true
  belongs_to :business_process, optional: true
end
