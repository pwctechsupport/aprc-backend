class PolicyItSystem < ApplicationRecord
  belongs_to :policy, optional: true
  belongs_to :it_system, class_name: "ItSystem", foreign_key: "it_system_id", optional: true
end
