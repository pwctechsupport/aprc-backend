class Resource < ApplicationRecord
  validates :name, uniqueness: true
  has_paper_trail ignore: [:visit, :recent_visit]
  has_drafts
  # belongs_to :policy, optional: true
  belongs_to :control, optional: true
  has_many :policy_resources,  class_name: "PolicyResource", foreign_key: "resource_id", dependent: :destroy
  has_many :policies, through: :policy_resources
  has_many :resource_controls ,  class_name: "ResourceControl", foreign_key: "resource_id", dependent: :destroy
  has_many :controls, through: :resource_controls
  attr_reader :resupload_remote_url
  has_attached_file :resupload
  validates_attachment :resupload, content_type: { content_type: ["image/jpeg", "image/gif", "image/png", "application/pdf", "application/xlsx","application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "text/plain", "application/zip", "application/x-zip", "application/x-zip-compressed","application/octet-stream","application/vnd.ms-office","application/vnd.openxmlformats-officedocument.presentationml.presentation", "application/vnd.ms-powerpoint"] }
  # validates_attachment_file_name :resupload, matches: [/\.pdf$/, /\.docx?$/, /\.xlsx?$/, /\.odt$/, /\.ods$/]
  # belongs_to :policy, optional: true, class_name: "Policy", foreign_key: "policy_id"
  # belongs_to :control, optional: true, class_name: "Control", foreign_key: "control_id"
  belongs_to :business_process, optional: true, class_name: "BusinessProcess", foreign_key: "business_process_id"
  has_many :resource_ratings, dependent: :destroy
  has_many :tags, dependent: :destroy
  accepts_nested_attributes_for :tags, allow_destroy: true
  has_many :request_edits, class_name: "RequestEdit", as: :originator, dependent: :destroy
  belongs_to :user_reviewer, class_name: "User", foreign_key:"user_reviewer_id", optional: true

  def to_humanize
    "#{self.name} : #{self.resupload_file_name}"
  end

  def request_edit
    request_edits.last
  end
  
  def resupload_remote_url=(url_value)
    self.resupload = URI.parse(url_value)
    @resupload_remote_url = url_value
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    allowed_attributes = ["name", "category", "status", "related control", "related policy", "related control description", "related policy title","related business process", "related business process name"]
    header = spreadsheet.row(1)
    resource_names = []
    pol_ids = []
    con_ids = []
    index_resource = 0
    (2..spreadsheet.last_row).each do |k|
      row = Hash[[header, spreadsheet.row(k)].transpose]
      if row["name"].present? && !Resource.find_by_name(row["name"]).present?
        if resource_names.count != 0
          resource_id = Resource&.find_by_name(resource_names[index_resource-1]).update(policy_ids: pol_ids, control_ids: con_ids)
          pol_ids.reject!{|x| x == x}
          con_ids.reject!{|x| x == x}
        end
        if !Resource.find_by_name(row["name"]).present?
          resource_names.push(row["name"])
        end
        resource_id = Resource&.create(name: resource_names[index_resource],category: row["category"], policy_ids: row["related policy"], control_ids: row["related control"], business_process_id: row["related business process"])
        index_resource+=1
      end
      pol_ids.push(row["related policy"])
      con_ids.push(row["related control"])
      if k == spreadsheet.last_row && Resource.find_by_name(row["name"]).present?
        if row["name"].present?
          if resource_names.count != 0
            resource_id = Resource&.find_by_name(resource_names[index_resource-1]).update(policy_ids: pol_ids, control_ids: con_ids)
            pol_ids.reject!{|x| x == x}
            con_ids.reject!{|x| x == x}
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

  def resource_file_type(res)
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
