class Control < ApplicationRecord
  serialize :assertion, Array
  serialize :ipo, Array
  has_many :control_business_processes, dependent: :destroy
  has_many :business_processes, through: :control_business_processes
  has_many :control_descriptions, class_name: "ControlDescription", foreign_key: "control_id", dependent: :destroy
  has_many :descriptions, through: :control_descriptions
  has_many :control_risks, class_name: "ControlRisk", foreign_key: "control_id", dependent: :destroy
  has_many :risks, through: :control_risks
  has_many :resource_controls, dependent: :destroy
  has_many :resources, through: :resource_controls
  has_many :policy_controls, dependent: :destroy
  has_many :policies, through: :policy_controls
end