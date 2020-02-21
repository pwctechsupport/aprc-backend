class PolicyCategory < ApplicationRecord
	has_paper_trail on: []

  # Add callbacks in the order you need.
  paper_trail.on_destroy    # add destroy callback
  paper_trail.on_update     # etc.
  paper_trail.on_create
  paper_trail.on_touch
  has_drafts
	
	validates :name, uniqueness: true
  has_many :policies, inverse_of: :policy_category
  accepts_nested_attributes_for :policies, allow_destroy: true
  has_many :user_policy_categories, dependent: :destroy
  has_many :users, through: :user_policy_categories
  belongs_to :user_reviewer, class_name: "User", foreign_key:"user_reviewer_id", optional: true
  def to_humanize
    "#{self.name}"
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    allowed_attributes = ["name", "related policy"]
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      policy_category_id = PolicyCategory.create(name: row["name"],policy_ids: row["related policy"].split("|"))
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
