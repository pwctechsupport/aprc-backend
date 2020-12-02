class Import < ApplicationRecord
  has_paper_trail

  has_attached_file :file
  validates_attachment :file, content_type: {content_type: %w(
    application/vnd.ms-excel
    application/msword
    application/vnd.ms-powerpoint
    application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
    application/vnd.openxmlformats-officedocument.spreadsheetml.template
    application/vnd.openxmlformats-officedocument.presentationml.template
    application/vnd.openxmlformats-officedocument.presentationml.slideshow
    application/vnd.openxmlformats-officedocument.presentationml.presentation
    application/vnd.openxmlformats-officedocument.presentationml.slide
    application/vnd.openxmlformats-officedocument.wordprocessingml.document
    application/vnd.openxmlformats-officedocument.wordprocessingml.template
    text/csv
    application/x-gzip
    application/zip
    application/pdf
    application/rtf
  )}

  def to_humanize
    "#{self.name} : #{self.file_file_name}"
  end
end
