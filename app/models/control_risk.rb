class ControlRisk < ApplicationRecord
  belongs_to :control
  belongs_to :risk, class_name: "Risk", foreign_key: "risk_id"
end
