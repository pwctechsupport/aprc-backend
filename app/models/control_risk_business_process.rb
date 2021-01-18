class ControlRiskBusinessProcess < ApplicationRecord
  has_drafts
  belongs_to :control
  belongs_to :risk_business_process, class_name: "RiskBusinessProcess", foreign_key: "risk_business_process_id"
end
