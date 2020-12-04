class Resource < ApplicationRecord
  validates :name, uniqueness: true
  validates_uniqueness_of :name, :case_sensitive => false
  has_paper_trail ignore: [:visit, :recent_visit, :updated_at]
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
    "#{self.name} : #{self.resupload_file_name || self.resupload_link}"
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
    allowed_attributes = ["name", "category","related policy title", "related business process name"]
    header = spreadsheet.row(1)
    resource_names = []
    pol_ids = []
    pol_obj = []
    bp_ids = []
    bp_obj= []
    error_data = []
    index_resource = 0
    ActiveRecord::Base.transaction do 
      (2..spreadsheet.last_row).each do |k|
        row = Hash[[header, spreadsheet.row(k)].transpose]
        if row["name"].present? && !Resource.find_by_name(row["name"]).present?
          if resource_names.count != 0
            resource_id = Resource&.find_by_name(resource_names[index_resource-1]).update(policy_ids: pol_ids.uniq, business_process_ids: bp_ids.uniq)
            pol_ids.reject!{|x| x == x}
            pol_obj.reject!{|x| x == x}
            bp_ids.reject!{|x| x == x}
            bp_obj.reject!{|x| x == x}
          end
          if !Resource.find_by_name(row["name"]).present?
            resource_names.push(row["name"])
          end
          resource_id = Resource&.create(name: resource_names[index_resource],category: row["category"], policy_ids: Policy.find_by(title: row["related policy title"])&.id, business_process_ids: BusinessProcess.find_by_name(row["related business process name"])&.id, status: "release", is_inside: true)
          
          unless resource_id.valid?
            error_data.push({message: resource_id.errors.full_messages.join(","), line: k})
          end

          index_resource+=1
        elsif !row["name"].present?
          error_data.push({message: "Resource name must Exist", line: k})
        end

        resource_inside = Resource.find_by_name(row["name"])
        if row["name"].present? && resource_inside.present?
          if !resource_inside.is_inside?
            error_data.push({message: "Resource data already exist, cannot edit Resource named  #{resource_inside&.name }. please remove it from the worksheet", line: k})
          end
        end

        if resource_inside.present?
          if resource_inside&.is_inside?
            if !row["related policy title"].nil?
              pol_obj.push({title: row["related policy title"]})
              pol_obj.each do |pol|
                if pol[:title].present?
                  main_pol = Policy.find_by(title: pol[:title])
                  if !main_pol.present?
                    error_data.push({message: "Policy must Exist", line: k})
                  end
                  if main_pol.present?
                    pol_ids.push(main_pol&.id)
                  end
                end
              end
            end

            if !row["related business process name"].nil?
              bp_obj.push({name: row["related business process name"]})
              bp_obj.each do |bp|
                if bp[:name].present?
                  main_bp = BusinessProcess.find_by_name(bp[:name])
                  if !main_bp.present?
                    error_data.push({message: "Business Process must Exist", line: k})
                  end
                  if main_bp.present?
                    bp_ids.push(main_bp&.id)
                    if main_bp.descendant_ids.present?
                      bp_ids.push(main_bp.descendant_ids)
                    end
                  end
                end
              end
            else
              error_data.push({message: "Business Process Must Exist", line: k})
            end

            if k == spreadsheet.last_row && Resource.find_by_name(row["name"]).present?
              if row["name"].present?
                if resource_names.count != 0
                  resource_id = Resource&.find_by_name(resource_names[index_resource-1]).update(policy_ids: pol_ids.uniq, business_process_ids: bp_ids.uniq)
                  pol_ids.reject!{|x| x == x}
                  bp_ids.reject!{|x| x == x}
                end
              end
            end
          end
        end
      end

      if error_data.count != 0
        raise ActiveRecord::Rollback, "Rollback Completed"
      end

      if Resource.where(is_inside: true).present?
        Resource.where(is_inside:true).map{|x| x.update(is_inside: false)}
      end
    end

    return true, error_data.uniq
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

  def self.rate(resource)
    rating_total = resource.resource_ratings.count
    rating_sum =  resource.resource_ratings.sum(:rating)
    rating_average = rating_sum/rating_total
    rating_round = rating_average.round(1)
    return rating_total, rating_sum, rating_average, rating_round
  end

  def self.resource_file_type(res)
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
