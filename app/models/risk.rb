class Risk < ApplicationRecord
  # validates :name, uniqueness: true
  validates_uniqueness_of :name, :scope => [:type_of_risk, :level_of_risk]
  has_paper_trail
  has_drafts
  serialize :business_process, Array
  has_many :control_risks, class_name: "ControlRisk", foreign_key: "risk_id", dependent: :destroy
  has_many :controls, through: :control_risks
  accepts_nested_attributes_for :controls, allow_destroy: true
  has_many :policy_risks, dependent: :destroy
  has_many :policies, through: :policy_risks
  has_many :risk_business_processes, dependent: :destroy
  has_many :business_processes, through: :risk_business_processes
  belongs_to :user, optional: true
  has_many :bookmark_risks
  has_many :users, through: :bookmark_risks
  has_many :bookmarks, class_name: "Bookmark", as: :originator, dependent: :destroy
  belongs_to :user_reviewer, class_name: "User", foreign_key:"user_reviewer_id", optional: true
  has_many :request_edits, class_name: "RequestEdit", as: :originator, dependent: :destroy
  has_many :tags, dependent: :destroy

  def request_edit
    request_edits.last
  end

  def to_humanize
    "#{self.name} : #{self.status}"
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    allowed_attributes = ["name", "level of risk", "status", "type of risk", "related business process", "related business process name"]
    header = spreadsheet.row(1)
    risk_names = []
    bp_ids = []
    index_risk = 0
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      if row["name"].present? && !Risk.find_by_name(row["name"]).present?
        if risk_names.count != 0
          risk_id = Risk.find_by_name(risk_names[index_risk-1]).update(business_process_ids: bp_ids)
          bp_ids.reject!{|x| x == x}
        end
        if !Risk.find_by_name(row["name"]).present?
          risk_names.push(row["name"])
        end
        risk_id = Risk.create(name: risk_names[index_risk],business_process_ids: row["related business process"], level_of_risk: row["level of risk"], type_of_risk: row["type of risk"])
        index_risk+=1
      end
      bp_ids.push(row["related business process"])
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
  
  def type_level_error
    if self.errors.details[:name].first[:error] == :taken
      raise GraphQL::ExecutionError, "The Level of Risk and Type of Risk combination for this Risk is not possible "
    end
  end

end