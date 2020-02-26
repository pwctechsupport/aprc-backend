class Control < ApplicationRecord
  has_paper_trail
  has_drafts
  validates :description, uniqueness: true
  serialize :assertion, Array
  serialize :ipo, Array
  has_many :control_business_processes, dependent: :destroy
  has_many :business_processes, through: :control_business_processes
  has_many :control_descriptions, class_name: "ControlDescription", foreign_key: "control_id", dependent: :destroy
  has_many :descriptions, through: :control_descriptions
  has_many :control_risks, class_name: "ControlRisk", foreign_key: "control_id", dependent: :destroy
  
  has_many :risks, through: :control_risks
  has_many :resource_controls, dependent: :destroy
  has_many :resources, through: :resource_controls
  has_many :policy_controls, dependent: :destroy
  has_many :policies, through: :policy_controls
  has_many :bookmark_controls
  has_many :users, through: :bookmark_controls
  has_many :bookmarks, class_name: "Bookmark", as: :originator, dependent: :destroy
  has_many :file_attachments, class_name: "FileAttachment", as: :originator, dependent: :destroy
  has_many :activity_controls, dependent: :destroy
  accepts_nested_attributes_for :activity_controls, allow_destroy: true
  belongs_to :user_reviewer, class_name: "User", foreign_key:"user_reviewer_id", optional: true
  has_many :request_edits, class_name: "RequestEdit", as: :originator, dependent: :destroy
  def to_humanize
    "#{self.control_owner} : #{self.description}"
  end

  def request_edit
    request_edits.last
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    allowed_attributes = ["control owner", "description", "type of control", "frequency", "nature", "assertion", "ipo", "status", "key control"]
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]      
      control_id = Control.find_or_create_by(description: row["description"], control_owner: row["control owner"], status: row["status"]&.gsub(" ","_")&.downcase, type_of_control: row["type of control"]&.gsub(" ","_")&.downcase, frequency: row["frequency"]&.downcase, nature: row["nature"]&.downcase, assertion: row["assertion"]&.split(",")&.map {|x| x&.gsub(" ","_")&.downcase}, ipo: row["ipo"]&.split(",").map {|x| x&.gsub(" ","_")&.downcase}, key_control: row["key control"])
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