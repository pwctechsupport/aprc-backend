class Import < ApplicationRecord
  has_paper_trail

  has_attached_file :file

  def to_humanize
    "#{self.name} : #{self.file_file_name}"
  end
end
