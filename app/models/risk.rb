class Risk < ApplicationRecord
  # has_many :control_risks, class_name: "ControlRisk", foreign_key: "risk_id", dependent: :destroy
  # has_many :controls, through: :control_risks
  has_many :controls
  has_many :policy_risks, dependent: :destroy
  has_many :policies, through: :policy_risks
  belongs_to :business_process, optional: true
end
