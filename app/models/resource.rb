class Resource < ApplicationRecord
  validates :name, uniqueness: true
  has_paper_trail ignore: [:visit]
  belongs_to :policy, optional: true
  belongs_to :control, optional: true
  has_many :policy_resources, dependent: :destroy
  has_many :policies, through: :policy_resources
  has_many :resource_controls, dependent: :destroy
  has_many :controls, through: :resource_controls
  has_attached_file :resupload
  validates_attachment :resupload, content_type: { content_type: ["image/jpeg", "image/gif", "image/png", "application/pdf", "application/xlsx","application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "text/plain", "application/zip", "application/x-zip", "application/x-zip-compressed","application/octet-stream","application/vnd.ms-office","application/vnd.openxmlformats-officedocument.presentationml.presentation", "application/vnd.ms-powerpoint"] }
  # validates_attachment_file_name :resupload, matches: [/\.pdf$/, /\.docx?$/, /\.xlsx?$/, /\.odt$/, /\.ods$/]
  # belongs_to :policy, optional: true, class_name: "Policy", foreign_key: "policy_id"
  # belongs_to :control, optional: true, class_name: "Control", foreign_key: "control_id"
  belongs_to :business_process, optional: true, class_name: "BusinessProcess", foreign_key: "business_process_id"
  has_many :resource_ratings

  def to_humanize
    "#{self.name} : #{self.resupload_file_name}"
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    allowed_attributes = ["name", "category", "status", "related control", "related policy"]
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      
      row = Hash[[header, spreadsheet.row(i)].transpose]
      if row["related policy"].class == Integer
        resource_id = Resource.create(name: row["name"], category: row["category"], control_ids: [row["related control"]], policy_ids: row["related policy"])
      else
        resource_id = Resource.create(name: row["name"], category: row["category"], control_ids: [row["related control"]], policy_ids: row["related policy"]&.split("|"))     
      end
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, packed: nil, file_warning: :ignore)
    else 
      raise "Unknown file type: #{file.original_filename}"
    end
  end

end
