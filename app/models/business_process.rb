class BusinessProcess < ApplicationRecord
  has_paper_trail
  validates :name, uniqueness: true
  has_many :policy_business_processes, dependent: :destroy
  has_many :policies, through: :policy_business_processes
  has_many :control_business_processes, dependent: :destroy
  has_many :controls, through: :control_business_processes
  has_ancestry
  has_many :resources, dependent: :destroy
  has_many :risks, dependent: :destroy
  has_many :bookmark_business_processes
  has_many :users, through: :bookmark_business_processes
  has_many :bookmarks, class_name: "Bookmark", as: :originator, dependent: :destroy

  def to_humanize
    "#{self.name} : #{self.status}"
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    allowed_attributes = ["name", "ancestry"]
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      business_process_id = BusinessProcess.find_or_create_by(name: row["name"], ancestry: BusinessProcess&.find_by(name: row["ancestry"])&.id)
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
