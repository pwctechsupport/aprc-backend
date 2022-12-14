class Risk < ApplicationRecord
  validates :name, uniqueness: true
  validates_presence_of :name, :type_of_risk, :level_of_risk
  validates_uniqueness_of :name, :case_sensitive => false

  # validates_uniqueness_of :name, :scope => [:type_of_risk, :level_of_risk]
  has_paper_trail ignore: [:updated_at, :is_inside, :published_at, :draft_id]
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

  def last_updated_by_user_id
    self&.draft&.whodunnit || self&.versions&.last&.whodunnit
  end
  
  def request_edit
    request_edits.last
  end

  def to_humanize
    "#{self.name} : #{self.status}"
  end

  def self.import(file, current_user=nil)
    spreadsheet = open_spreadsheet(file)
    allowed_attributes = ["name", "level of risk", "type of risk", "related business process name"]
    header = spreadsheet.row(1)
    if header.present?
      header.map! {|x| x.downcase}
    end
    risk_names = []
    bp_ids = []
    bp_obj= []
    collected_risk = []
    collected_bp = []
    error_data = []
    index_risk = 0
    spread_count = spreadsheet.row(2).count
    spread_nil = spreadsheet.row(2).group_by(&:itself).map { |k,v| [k, v.length] }.to_h
    if spread_nil[nil] == spread_count
      error_data.push({message: "Risk cannot be empty", line: 2})
    end
    
    ActiveRecord::Base.transaction do
      (2..spreadsheet.last_row).each do |k|
        row = Hash[[header, spreadsheet.row(k)].transpose]
        if !header.present?
          error_data.push({message: "Risk's Headers does not exist", line: 1})
        end
        if header.sort != allowed_attributes.sort
          error_data.push({message: "Incorrect Header, Please follow the existing template", line: 1})
        end
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
            # error_data.push({message: "Level of Risk must exist", line: k})
            row_level_of_risk = row["level of risk"]
          end
  
          if row["type of risk"].present?
            row_type_of_risk = row["type of risk"]&.gsub(/[^\w]/, '_')&.downcase
          else
            # error_data.push({message: "Type of Risk must exist", line: k})
            row_type_of_risk = row["type of risk"]
          end

          # bispro not mandatory
          # if !BusinessProcess.find_by_name(row["related business process name"]).present?
          #   error_data.push({message: "Business Process must exist", line: k})
          # end
  
          risk_id = Risk.create(name: risk_names[index_risk],business_process_ids: BusinessProcess.find_by_name(row["related business process name"])&.id, level_of_risk: row_level_of_risk, type_of_risk: row_type_of_risk, status: "release", is_inside: true, created_by: current_user&.name, last_updated_by: current_user&.name)
          unless risk_id.valid?
            error_data.push({message: risk_id.errors.full_messages.join(","), line: k})
          end
          index_risk+=1
        elsif !row["name"].present?
          error_data.push({message: "Risk name must exist", line: k})
        end
  
        risk_inside = Risk.find_by_name(row["name"]) 
        if row["name"].present? && risk_inside.present?
          if !risk_inside.is_inside?
            error_data.push({message: "Risk data already exist, cannot edit risk named  #{risk_inside&.name }. please remove it from the worksheet", line: k})
          end
        end
  
        if risk_inside.present?
          if risk_inside&.is_inside?
            if !row["related business process name"].nil?
              bp_obj.push({name: row["related business process name"]})
              bp_obj.each do |bp|
                if bp[:name].present?
                  main_bp = BusinessProcess.find_by_name(bp[:name])

                  # if !main_bp.present?
                  #   error_data.push({message: "Business Process must exist", line: k})
                  # end

                  if main_bp.present?
                    # bispro relation only for sub level
                    if main_bp.ancestry.present?
                      bp_ids.push(main_bp&.id) if main_bp&.id&.present?
                    else
                      error_data.push({message: "Can't assign main business process to risk, please change relation to sub level business process", line: k})
                    end

                    # if main_bp.descendant_ids.present?
                    #   bp_ids.concat(main_bp.descendant_ids)
                    # end
                  end
                end
              end
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