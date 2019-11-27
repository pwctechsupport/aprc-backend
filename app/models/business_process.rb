class BusinessProcess < ApplicationRecord
  has_many :policy_business_processes
  has_many :policies, through: :policy_business_processes
end
