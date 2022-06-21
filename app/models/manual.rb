class Manual < ApplicationRecord
  belongs_to :user, optional: true
  has_attached_file :resupload
  validates_attachment :resupload, content_type: { content_type: ["image/jpeg", "image/gif", "image/png", "application/pdf", "application/xlsx","application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "text/plain", "application/zip", "application/x-zip", "application/x-zip-compressed","application/octet-stream","application/vnd.ms-office","application/vnd.openxmlformats-officedocument.presentationml.presentation", "application/vnd.ms-powerpoint"] }
  def self.resource_file_type(res)
    content = res.resupload_content_type
    if content === nil
      content_true = ""
    else
      content_true = content.to_s
      if content_true.include? "wordprocessingml"
        content_true = ".docx"
        content_true
      elsif content_true.include? "sheet"
        content_true = ".xlsx"
        content_true
      elsif content_true.include? "presentation"
        content_true = ".pptx"
        content_true
      elsif content_true.include? "plain"
        content_true = ".txt"
        content_true
      else
        if content_true == nil
          content_true = ""
        else
          content_index = content_true.index("/")
          content_name = content_true[content_true.index('/',content_index - 1)..-1]
          content_file = content_name.sub("/","")
          contender = "." << content_file
          contender
        end
      end
    end
  end
end
