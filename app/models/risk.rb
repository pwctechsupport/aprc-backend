class Risk < ApplicationRecord
  has_many :control_risks, class_name: "ControlRisk", foreign_key: "risk_id"
  has_many :controls, through: :control_risks
end
