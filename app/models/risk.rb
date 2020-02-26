class Risk < ApplicationRecord
  validates :name, uniqueness: true
  has_paper_trail
  has_drafts
  has_many :control_risks, class_name: "ControlRisk", foreign_key: "risk_id", dependent: :destroy
  has_many :controls, through: :control_risks
  has_many :policy_risks, dependent: :destroy
  has_many :policies, through: :policy_risks
  belongs_to :business_process, class_name: "BusinessProcess", foreign_key: "business_process_id",  optional: true
  belongs_to :user, optional: true
  has_many :bookmark_risks
  has_many :users, through: :bookmark_risks
  has_many :bookmarks, class_name: "Bookmark", as: :originator, dependent: :destroy
  belongs_to :user_reviewer, class_name: "User", foreign_key:"user_reviewer_id", optional: true
  has_many :request_edits, class_name: "RequestEdit", as: :originator, dependent: :destroy

  def request_edit
    request_edits.last
  end

  def to_humanize
    "#{self.name} : #{self.status}"
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    allowed_attributes = ["name", "level of risk", "status", "type of risk", "business process"]
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      
      row = Hash[[header, spreadsheet.row(i)].transpose]
      bp_id = row["business process"]
      bispro = BusinessProcess.find_by(name: bp_id)
      
      risk_id = Risk.find_or_create_by(name: row["name"], level_of_risk: row["level of risk"], status: row["status"], type_of_risk: row["type of risk"], business_process_id: bispro&.id)
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