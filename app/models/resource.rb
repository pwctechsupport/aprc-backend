class Resource < ApplicationRecord
  has_many :policy_resources
  has_many :policies, through: :policy_resources
  has_many :resource_controls, dependent: :destroy
  has_many :controls, through: :resource_cotrols, dependent: :destroy
  has_attached_file :resupload
  validates_attachment :resupload, content_type: { content_type: ["image/jpeg", "image/gif", "image/png", "application/pdf"] }
end
