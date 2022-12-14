class ControlRiskBusinessProcess < ApplicationRecord
  has_paper_trail ignore: [:published_at, :draft_id]
  has_drafts
  belongs_to :control
  belongs_to :risk_business_process, class_name: "RiskBusinessProcess", foreign_key: "risk_business_process_id"

  def to_humanize
    "#{self.control&.description} : #{self.risk_business_process&.risk&.name} : #{self.risk_business_process&.business_process&.name}"
  end

end
