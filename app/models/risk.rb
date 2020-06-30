class Risk < ApplicationRecord
  validates :name, uniqueness: true
  validates_presence_of :name, :type_of_risk, :level_of_risk

  # validates_uniqueness_of :name, :scope => [:type_of_risk, :level_of_risk]
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

  validate :validate_type_of_risk
  validate :validate_level_of_risk


  def request_edit
    request_edits.last
  end

  def to_humanize
    "#{self.name} : #{self.status}"
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    allowed_attributes = ["name", "level of risk", "type of risk", "related business process name", "related sub business process 1", "related sub business process 2"]
    header = spreadsheet.row(1)
    risk_names = []
    bp_ids = []
    bp_obj= []
    collected_risk = []
    collected_bp = []
    error_data = []
    index_risk = 0
    
    ActiveRecord::Base.transaction do
      (2..spreadsheet.last_row).each do |k|
        row = Hash[[header, spreadsheet.row(k)].transpose]
        if row["name"].present? && !Risk.find_by_name(row["name"]).present?
          if risk_names.count != 0
            risk_obj = Risk.find_by_name(risk_names[index_risk-1])
            if risk_obj.present?
              risk_id = risk_obj.update(business_process_ids: bp_ids.uniq)
              if risk_obj&.business_processes.present?
                ris_bus = risk_obj&.business_processes&.map{|x| x.name}
                risk_obj&.update(business_process: ris_bus)
              end
            end
            bp_ids.reject!{|x| x == x}
            bp_obj.reject!{|x| x == x}
          end
          if !Risk.find_by_name(row["name"]).present?
            risk_names.push(row["name"])
          end
  
          if row["level of risk"].present?
            row_level_of_risk = row["level of risk"]&.gsub(/[^\w]/, '_')&.downcase
          else
            # error_data.push({message: "Level of Risk must Exist", line: k})
            row_level_of_risk = row["level of risk"]
          end
  
          if row["type of risk"].present?
            row_type_of_risk = row["type of risk"]&.gsub(/[^\w]/, '_')&.downcase
          else
            # error_data.push({message: "Type of Risk must Exist", line: k})
            row_type_of_risk = row["type of risk"]
          end
  
          risk_id = Risk.create(name: risk_names[index_risk],business_process_ids: BusinessProcess.find_by_name(row["related business process name"])&.id, level_of_risk: row_level_of_risk, type_of_risk: row_type_of_risk, status: "release", is_inside: true)
          unless risk_id.valid?
            error_data.push({message: risk_id.errors.full_messages.join(","), line: k})
          else
            collected_risk.push(risk_id&.id)
          end
          index_risk+=1
        elsif !row["name"].present?
          error_data.push({message: "Risk name must Exist", line: k})
        end
  
        risk_inside = Risk.find_by_name(row["name"]) 
        if row["name"].present? && risk_inside.present?
          if !risk_inside.is_inside?
            error_data.push({message: "Risk data exist, cannot edit risk named  #{risk_inside&.name }. please remove it from the worksheet", line: k})
          end
        end
  
        if risk_inside.present?
          if risk_inside&.is_inside?
            if !row["related business process name"].nil?
              bp_obj.push({name: row["related business process name"], sub1: row["related sub business process 1"], sub2: row["related sub business process 2"]})
              bp_obj.each do |bp|
                if bp[:name].present?
                  main_bp = BusinessProcess.find_by_name(bp[:name])
                  if !main_bp.present?
                    error_data.push({message: "Business Process must Exist", line: k})
                  end
                  if main_bp.present?
                    bp_ids.push(main_bp&.id)
                  end
                  if bp[:sub1].present?
                    if bp[:name].downcase == bp[:sub1].downcase
                      error_data.push({message: "Business Process and Sub Business Process 1 cannot have the same name", line: k})
                    end
                    bispro = BusinessProcess.find_by_name(bp[:sub1])
                    if bispro.present?
                      if bispro&.parent_id.present?
                        if bispro.parent_id == main_bp&.id
                          bp_ids.push(bispro&.id)
                          if bp[:sub2].present?
                            if bp[:sub1].downcase == bp[:sub2].downcase
                              error_data.push({message: "Sub Business Process 1 and Sub Business Process 2 cannot have the same name", line: k})
                            end
                            if bp[:name].downcase == bp[:sub2].downcase
                              error_data.push({message: "Business Process and Sub Business Process 2 cannot have the same name", line: k})
                            end
                            bispro_2 = BusinessProcess.find_by_name(bp[:sub2]) 
                            if bispro_2.present?
                              if bispro_2.parent_id.present?
                                if bispro_2&.parent_id == bispro&.id
                                  bp_ids.push(bispro_2&.id)
                                else
                                  error_data.push({message: "Sub Business Process 2 belongs to another parent", line: k})
                                end
                              else
                                bispro_2.update(parent_id: bispro&.id)
                              end
                            end
                          end
                        else
                          error_data.push({message: "Sub Business Process 1 belongs to another parent", line: k})
                        end
                      else
                        bispro.update(parent_id: main_bp&.id)
                      end
                    else
                      if bp[:sub2].present?
                        bispro_2 = BusinessProcess.find_by_name(bp[:sub2]) 
                        if bispro_2.present?
                          error_data.push({message: "Sub Business Process 1 is empty, cannot assign Sub Business Process 2", line: k})
                        end
                      end
                    end
                  else
                    if bp[:sub2].present?
                      error_data.push({message: "Sub Business Process 2 is invalid because Sub Business Process 1 is missing ", line: k})
                    end
                  end
                end
              end
            else
              error_data.push({message: "Business Process Must Exist", line: k})
            end
            if k == spreadsheet.last_row && Risk.find_by_name(row["name"]).present?
              if row["name"].present?
                if risk_names.count != 0
                  risk_obj = Risk.find_by_name(risk_names[index_risk-1])
                  risk_id = risk_obj.update(business_process_ids: bp_ids.uniq)
                  if risk_obj&.business_processes.present?
                    ris_bus = risk_obj&.business_processes&.map{|x| x.name}
                    risk_obj&.update(business_process: ris_bus)
                  end
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

      if Risk.where(is_inside: true).present?
        Risk.where(is_inside:true).map{|x| x.update(is_inside: false)}
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
  
  def type_level_error
    if self.errors.details[:name].first[:error] == :taken
      raise GraphQL::ExecutionError, "The Level of Risk and Type of Risk combination for this Risk is not possible "
    end
  end

  private 
    def validate_type_of_risk
      tor_value = Types::Enums::TypeOfRisk.values.map{|x| x[1].value}
      tor  = self.type_of_risk
      unless tor_value.include? tor
        self.errors.add(:type_of_risk, :type_of_risk_invalid,
          message: "does not exist")
      end
    end

    def validate_level_of_risk
      lor_value = Types::Enums::LevelOfRisk.values.map{|x| x[1].value}
      lor  = self.level_of_risk
      unless lor_value.include? lor
        self.errors.add(:level_of_risk, :level_of_risk_invalid,
          message: "does not exist")
      end
    end

end