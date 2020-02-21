class ActivityControl < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :control, optional: true

  
  
  has_attached_file :resupload
  validates_attachment :resupload, content_type: { content_type: ["image/jpeg", "image/gif", "image/png", "application/pdf", "application/xlsx","application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "text/plain", "application/zip", "application/x-zip", "application/x-zip-compressed","application/octet-stream","application/vnd.ms-office","application/vnd.openxmlformats-officedocument.presentationml.presentation", "application/vnd.ms-powerpoint"] }
 
end
