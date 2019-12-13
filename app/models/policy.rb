class Policy < ApplicationRecord
  belongs_to :policy_category, optional: true
  belongs_to :user, optional: true
  has_many :policy_resources, dependent: :destroy
  has_many :policy_business_processes, dependent: :destroy
  has_many :policy_it_systems, class_name: "PolicyItSystem", foreign_key: "policy_id", dependent: :destroy
  has_many :resources, through: :policy_resources
  has_many :it_systems, through: :policy_it_systems
  has_many :business_processes, through: :policy_business_processes
  has_ancestry
  has_many :policy_references, dependent: :destroy
  has_many :references, through: :policy_references
  has_many :policy_controls, dependent: :destroy
  has_many :controls, through: :policy_controls
  has_many :policy_risks, dependent: :destroy
  has_many :risks, through: :policy_risks
end