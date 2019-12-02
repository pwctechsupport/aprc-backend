class BusinessProcess < ApplicationRecord
  has_many :policy_business_processes
  has_many :policies, through: :control_business_processes
  has_many :control_business_processes
  has_many :controls, through: :control_business_processes
  has_ancestry
  has_many :resources
end
