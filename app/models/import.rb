class Import < ApplicationRecord
  has_paper_trail

  has_attached_file :file
  validates_attachment_content_type :file, content_type: { content_type: ["image/jpeg", "image/gif", "image/png", "application/pdf", "application/xlsx","application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "text/plain", "application/zip", "application/x-zip", "application/x-zip-compressed","application/octet-stream","application/vnd.ms-office","application/vnd.openxmlformats-officedocument.presentationml.presentation", "application/vnd.ms-powerpoint"] }

  def to_humanize
    "#{self.name} : #{self.file_file_name}"
  end
end
