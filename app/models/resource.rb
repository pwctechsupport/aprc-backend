class Resource < ApplicationRecord
  has_many :policy_resources, dependent: :destroy
  has_many :policies, through: :policy_resources
  has_many :resource_controls, dependent: :destroy
  has_many :controls, through: :resource_controls
  has_attached_file :resupload
  validates_attachment :resupload, content_type: { content_type: ["image/jpeg", "image/gif", "image/png", "application/pdf"] }
  # belongs_to :policy, optional: true, class_name: "Policy", foreign_key: "policy_id"
  # belongs_to :control, optional: true, class_name: "Control", foreign_key: "control_id"
  belongs_to :business_process, optional: true, class_name: "BusinessProcess", foreign_key: "business_process_id"
  has_many :resource_ratings
end
