class BusinessProcess < ApplicationRecord
  validates :name, uniqueness: true
  has_many :policy_business_processes, dependent: :destroy
  has_many :policies, through: :policy_business_processes
  has_many :control_business_processes, dependent: :destroy
  has_many :controls, through: :control_business_processes
  has_ancestry
  has_many :resources, dependent: :destroy
  has_many :risks, dependent: :destroy
end
