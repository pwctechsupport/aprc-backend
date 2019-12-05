class Control < ApplicationRecord
  has_many :control_business_processes, dependent: :destroy
  has_many :business_processes, through: :control_business_processes, dependent: :destroy
  has_many :control_risks, class_name: "ControlRisk", foreign_key: "control_id", dependent: :destroy
  has_many :risks, through: :control_risks, dependent: :destroy
  has_many :resource_controls, dependent: :destroy
  has_many :resources, through: :resource_controls, dependent: :destroy
end