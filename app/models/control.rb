class Control < ApplicationRecord
  has_paper_trail
  has_drafts
  validates :description, uniqueness: true
  serialize :assertion, Array
  serialize :ipo, Array
  serialize :control_owner, Array
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
  has_many :tags, dependent: :destroy
  has_many :control_departments, dependent: :destroy
  has_many :departments, through: :control_departments

  def to_humanize
    "#{self.description} : #{self.description}"
  end

  def request_edit
    request_edits.last
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    allowed_attributes = [ "description", "type of control", "frequency", "nature", "assertion", "ipo", "status", "key control", "related business process", "related business process name", "related risk", "related risk name", "related control owner", "related control owner name"]
    header = spreadsheet.row(1)
    control_descriptions = []
    risk_ids = []
    bp_ids = []
    co_ids = []
    index_control = 0
    (2..spreadsheet.last_row).each do |k|
      row = Hash[[header, spreadsheet.row(k)].transpose]
      if row["description"].present? && !Control.find_by(description: row["description"]).present?
        if control_descriptions.count != 0
          control_obj = Control&.find_by(description:control_descriptions[index_control-1])
          control_id = control_obj&.update(risk_ids: risk_ids.uniq, business_process_ids: bp_ids.uniq, department_ids:co_ids.uniq, status: "release")
          if control_obj&.departments.present?
            con_dep = control_obj&.departments&.map{|x| x.name}
            control_obj&.update(control_owner: con_dep)
          end
          risk_ids&.reject!{|x| x == x}
          bp_ids&.reject!{|x| x == x}
          co_ids&.reject!{|x| x == x}
        end
        if !Control.find_by(description: row["description"]).present?
          control_descriptions.push(row["description"])
        end
        control_id = Control&.create(description: control_descriptions[index_control],status: row["status"]&.gsub(" ","_")&.downcase, type_of_control: row["type of control"]&.gsub(" ","_")&.downcase, frequency: row["frequency"]&.downcase, nature: row["nature"]&.downcase, assertion: row["assertion"]&.split(",")&.map {|x| x&.gsub(" ","_")&.downcase}, ipo: row["ipo"]&.split(",").map {|x| x&.gsub(" ","_")&.downcase}, key_control: row["key control"],risk_ids: row["related risk"], business_process_ids: row["related business process"], department_ids: row["related control owner"])
        index_control+=1
      end
      risk_ids.push(row["related risk"])
      bp_ids.push(row["related business process"])
      if !row["related control owner"].nil?
        co_ids.push(row["related control owner"])
      end
      if k == spreadsheet.last_row && Control.find_by(description: row["description"]).present?
        if row["description"].present?
          if control_descriptions.count != 0
            control_obj = Control&.find_by(description:control_descriptions[index_control-1])
            control_id = control_obj&.update(risk_ids: risk_ids.uniq, business_process_ids: bp_ids.uniq, department_ids:co_ids.uniq)
            if control_obj&.departments.present?
              con_dep = control_obj&.departments&.map{|x| x.name}
              control_obj&.update(control_owner: con_dep)
            end
            risk_ids&.reject!{|x| x == x}
            bp_ids&.reject!{|x| x == x}
            co_ids&.reject!{|x| x == x}
          end
        end
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

  def convert_ipo
    if self.ipo.present?
      converted_ipo = []
      self.ipo.collect do |i|
        if i == "completeness"
          converted_ipo.push("C")
        elsif i == "accuracy"
          converted_ipo.push("A")
        elsif i == "validation"
          converted_ipo.push("V")
        elsif i == "restriction"
          converted_ipo.push("R")
        end
      end
      converted_ipo
    else
      converted_ipo = []
    end
  end

  def convert_assertion
    if self.assertion.present?
      converted_assertion =[]
      self.assertion.each do |i|
        if i == "completeness"
          converted_assertion.push("C")
        elsif i == "accuracy"
          converted_assertion.push("A")
        elsif i == "validation"
          converted_assertion.push("V")
        elsif i == "existence_and_occurence"
          converted_assertion.push("E/O")
        elsif i == "rights_and_obligation"
          converted_assertion.push("R&O")
        elsif i == "presentation_and_disclosure"
          converted_assertion.push("P&D")
        end
      end
      converted_assertion
    else
      converted_assertion = []
    end
  end
end