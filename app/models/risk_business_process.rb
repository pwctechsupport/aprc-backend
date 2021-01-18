class RiskBusinessProcess < ApplicationRecord
  # has_paper_trail on: []

  # # Add callbacks in the order you need.
  # paper_trail.on_destroy    # add destroy callback
  # paper_trail.on_update     # etc.
  # paper_trail.on_create
  # paper_trail.on_touch
  belongs_to :risk, optional: true
  belongs_to :business_process, optional: true
  has_many :control_risk_business_processes , class_name: "ControlRiskBusinessProcess", foreign_key: "risk_business_process_id"
  has_many :controls, through: :control_risk_business_processes
  def to_humanize
    "#{self.risk&.name} : #{self.business_process&.name}"
  end
end
