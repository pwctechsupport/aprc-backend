class Policy < ApplicationRecord
  belongs_to :policy_category
  belongs_to :user, optional: true
  has_many :policy_resources
  has_many :policy_business_processes
  has_many :policy_it_systems, class_name: "PolicyItSystem", foreign_key: "policy_id"
  has_many :resources, through: :policy_resources
  has_many :it_systems, through: :policy_it_systems
  has_many :business_processes, through: :policy_business_processes
end