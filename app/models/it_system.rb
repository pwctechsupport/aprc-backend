class ItSystem < ApplicationRecord
  has_many :policy_it_systems, class_name: "PolicyItSystem", foreign_key: "it_system_id"
  has_many :policies, through: :policy_it_systems
end