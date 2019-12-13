class Description < ApplicationRecord
  has_many :control_descriptions, class_name: "ControlDescription", foreign_key: "description_id"
  has_many :controls, through: :control_descriptions
end
