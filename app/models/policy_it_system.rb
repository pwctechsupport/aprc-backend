class PolicyItSystem < ApplicationRecord
  belongs_to :policy
  belongs_to :it_system, class_name: "ItSystem", foreign_key: "it_system_id"
end
