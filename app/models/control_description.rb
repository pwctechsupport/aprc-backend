class ControlDescription < ApplicationRecord
  belongs_to :control
  belongs_to :description, class_name: "Description", foreign_key: "description_id"
end
