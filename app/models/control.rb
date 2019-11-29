class Control < ApplicationRecord
  has_many :control_business_processes, dependent: :destroy
  has_many :business_processes, through: :control_business_processes, dependent: :destroy
  has_many :control_descriptions, class_name: "ControlDescription", foreign_key: "control_id", dependent: :destroy
  has_many :descriptions, through: :control_descriptions, dependent: :destroy
  has_many :control_risks, class_name: "ControlRisk", foreign_key: "control_id", dependent: :destroy
  has_many :risks, through: :control_risks, dependent: :destroy
end