class Control < ApplicationRecord
  has_paper_trail
  has_drafts
  validates_presence_of :description, :type_of_control, :frequency, :nature, :assertion, :ipo
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

  validate :validate_type_of_control
  validate :validate_frequency
  validate :validate_nature
  validate :validate_assertion
  validate :validate_ipo

  def to_humanize
    "#{self.description} : #{self.description}"
  end

  def self.to_export(sheet,control, business_process,risk,owner,activity_control)
    if business_process.present?
      if business_process.ancestors.count == 0
        if business_process.children.present?
          business_process.children.each do |bp_1|
            if bp_1.ancestors.count == 1
              if bp_1.children.present?
                bp_1.children.each do |bp_2|
                  if bp_2.ancestors.count == 2
                    sheet.add_row [control&.description&.titlecase, control&.type_of_control&.gsub(/_/, ' ')&.titlecase, control&.frequency, control&.nature&.titlecase, control&.assertion&.join(",")&.gsub(/_/, ' ')&.titlecase, control&.ipo.join(",")&.gsub(/_/, ' ')&.titlecase, control&.key_control, business_process&.name, bp_1.name, bp_2.name, risk&.name,owner, activity_control&.activity, activity_control&.guidance]
                  end
                end
              else
                sheet.add_row [control&.description&.titlecase, control&.type_of_control&.gsub(/_/, ' ')&.titlecase, control&.frequency, control&.nature&.titlecase, control&.assertion&.join(",")&.gsub(/_/, ' ')&.titlecase, control&.ipo.join(",")&.gsub(/_/, ' ')&.titlecase, control&.key_control, business_process&.name, bp_1.name, "", risk&.name,owner, activity_control&.activity, activity_control&.guidance]
              end
            end
          end
        else
          sheet.add_row [control&.description&.titlecase, control&.type_of_control&.gsub(/_/, ' ')&.titlecase, control&.frequency, control&.nature&.titlecase, control&.assertion&.join(",")&.gsub(/_/, ' ')&.titlecase, control&.ipo.join(",")&.gsub(/_/, ' ')&.titlecase, control&.key_control, business_process&.name, "", "", risk&.name,owner, activity_control&.activity, activity_control&.guidance]
        end
      end
    else
      sheet.add_row [control&.description&.titlecase, control&.type_of_control&.gsub(/_/, ' ')&.titlecase, control&.frequency, control&.nature&.titlecase, control&.assertion&.join(",")&.gsub(/_/, ' ')&.titlecase, control&.ipo.join(",")&.gsub(/_/, ' ')&.titlecase, control&.key_control,"", "", "", risk&.name,owner, activity_control&.activity, activity_control&.guidance]
    end
  end

  def request_edit
    request_edits.last
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    allowed_attributes = [ "description", "type of control", "frequency", "nature", "assertion", "ipo", "key control", "related business process name","related sub business process 1", "related sub business process 2","related risk name","related control owner name", "control activity title", "control activity guidance"]
    header = spreadsheet.row(1)
    control_descriptions = []
    risk_ids = []
    bp_ids = []
    co_ids = []
    risk_obj = []
    co_obj = []
    bp_obj = []
    collected_control=[]
    collected_risk =[]
    collected_bp = []
    collected_co = []
    activity_obj = []
    error_data = []
    index_control = 0
    ActiveRecord::Base.transaction do
      (2..spreadsheet.last_row).each do |k|
        row = Hash[[header, spreadsheet.row(k)].transpose]
        if row["description"].present? && !Control.find_by(description: row["description"]).present?
          if control_descriptions.count != 0
            control_obj = Control&.find_by(description:control_descriptions[index_control-1])
            active_control = []
            if activity_obj.count != 0
              active_control = activity_obj.uniq
            end
            control_id = control_obj&.update(risk_ids: risk_ids.uniq, business_process_ids: bp_ids.uniq, department_ids:co_ids.uniq, status: "release", activity_controls_attributes:active_control)
            if control_obj&.departments.present?
              con_dep = control_obj&.departments&.map{|x| x.name}
              control_obj&.update(control_owner: con_dep)
            end
            risk_ids&.reject!{|x| x == x}
            bp_ids&.reject!{|x| x == x}
            co_ids&.reject!{|x| x == x}
            bp_obj&.reject!{|x| x == x}
            risk_obj&.reject!{|x| x == x}
            co_obj&.reject!{|x| x == x}
            activity_obj&.reject!{|x| x == x}
          end
          if !Control.find_by(description: row["description"]).present?
            control_descriptions.push(row["description"])
          end
          if row["assertion"].present?
            row_assertion = row["assertion"]&.split(",").map {|x| x&.gsub(" ","_")&.downcase}
          else
            # error_data.push({message: "Assertion must Exist", line: k})
            row_assertion = row["assertion"]
          end

          if row["ipo"].present?
            row_ipo = row["ipo"]&.split(",").map {|x| x&.gsub(" ","_")&.downcase}
          else
            # error_data.push({message: "IPO must Exist", line: k})
            row_ipo = row["ipo"]
          end

          if row["nature"].present?
            row_nature = row["nature"]&.gsub(/[^\w]/, '_')&.downcase
          else
            # error_data.push({message: "Nature must Exist", line: k})
            row_nature = row["nature"]
          end

          if row["frequency"].present?
            row_frequency = row["frequency"]&.gsub(/[^\w]/, '_')&.downcase
          else
            # error_data.push({message: "Frequency must Exist", line: k})
            row_frequency = row["frequency"]
          end

          if row["type of control"].present?
            row_type_of_control = row["type of control"]&.gsub(/[^\w]/, '_')&.downcase
          else
            # error_data.push({message: "Type of Control must Exist", line: k})
            row_type_of_control = row["type of control"]
          end

          
          control_id = Control&.create(description: control_descriptions[index_control],status: "release", type_of_control: row_type_of_control, frequency: row_frequency, nature: row_nature, assertion: row_assertion, ipo: row_ipo, key_control: row["key control"],risk_ids: row["related risk"], business_process_ids: row["related business process"], department_ids: row["related control owner"], is_inside: true)
          unless control_id.valid?
            error_data.push({message: control_id.errors.full_messages.join(","), line: k})
          else
            collected_control.push(control_id&.id)
          end
          index_control+=1
        elsif !row["description"].present?
          error_data.push({message: "Control Description Must Exist", line: k})
        end

        control_inside = Control.find_by(description: row["description"]) 
        if row["description"].present? && control_inside.present?
          if !control_inside.is_inside?
            error_data.push({message: "Control data exist, cannot edit control with description named #{control_inside&.description }. please remove it from the worksheet", line: k})
          end
        end

        if control_inside.present? 
          if control_inside.is_inside?
            if !row["control activity title"].nil?
              activity_obj.push({activity:row["control activity title"], guidance: row["control activity guidance"]})
            end

            if !row["related risk name"].nil?
              risk_obj.push({name: row["related risk name"]})
              risk_obj.each do |ri|
                if ri[:name].present?
                  main_risk = Risk.find_by_name(ri[:name])
                  if !main_risk.present?
                    error_data.push({message: "Risk must Exist", line: k})
                  end
                  if main_risk.present?
                    risk_ids.push(main_risk&.id)
                  end
                end
              end
            else
              error_data.push({message: "Risk Must Exist", line: k})
            end

            if !row["related business process name"].nil?
              bp_obj.push({name: row["related business process name"], sub1: row["related sub business process 1"], sub2: row["related sub business process 2"], line: k})
              bp_obj.each do |bp|
                if bp[:name].present?
                  main_bp = BusinessProcess.find_by_name(bp[:name])
                  if !main_bp.present?
                    error_data.push({message: "Business Process must Exist", line: k})
                  end
                  if main_bp.present?
                    risk_check = Risk.find_by_name(spreadsheet.row(bp[:line])[10])
                    if risk_check.present?
                      if risk_check.business_processes.pluck(:name).include? main_bp.name
                        bp_ids.push(main_bp&.id)
                      else
                        error_data.push({message: "Business Process is not related to risk", line: k})
                      end
                    end
                  end
                  if bp[:sub1].present?
                    if bp[:name].downcase == bp[:sub1].downcase
                      error_data.push({message: "Business Process and Sub Business Process 1 cannot have the same name", line: k})
                    end
                    bispro = BusinessProcess.find_by_name(bp[:sub1])
                    if bispro.present?
                      if bispro&.parent_id.present?
                        if bispro.parent_id == main_bp&.id
                          risk_check = Risk.find_by_name(spreadsheet.row(bp[:line])[10])
                          if risk_check.present?
                            if risk_check.business_processes.pluck(:name).include? bispro.name
                              bp_ids.push(bispro&.id)
                            else
                              error_data.push({message: "Sub Business Process 1 is not related to Risk", line: k})
                            end
                          end
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
                                  risk_check = Risk.find_by_name(spreadsheet.row(bp[:line])[10])
                                  if risk_check.present?
                                    if risk_check.business_processes.pluck(:name).include? bispro_2.name
                                      bp_ids.push(bispro_2&.id)
                                    else
                                      error_data.push({message: "Sub Business Process 2 is not related to risk", line: k})
                                    end
                                  end
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

            if !row["related control owner name"].nil?
              co_obj.push({name: row["related control owner name"]})
              co_obj.each do |co|
                if co[:name].present?
                  main_co = Department.find_by_name(co[:name])
                  if !main_co.present?
                    error_data.push({message: "Control Owner must Exist", line: k})
                  end
                  if main_co.present?
                    co_ids.push(main_co&.id)
                  end
                end
              end
            else
              error_data.push({message: "Control Owner Must Exist", line: k})
            end
            if k == spreadsheet.last_row && Control.find_by(description: row["description"]).present?
              if row["description"].present?
                if control_descriptions.count != 0
                  control_obj = Control&.find_by(description:control_descriptions[index_control-1])
                  active_control = []
                  if activity_obj.count != 0
                    active_control = activity_obj.uniq
                  end
                  control_id = control_obj&.update(risk_ids: risk_ids.uniq, business_process_ids: bp_ids.uniq, department_ids:co_ids.uniq, status: "release", activity_controls_attributes:active_control)
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
      end

      if error_data.count != 0
        raise ActiveRecord::Rollback, "Rollback Completed"
      end
      if Control.where(is_inside: true).present?
        Control.where(is_inside:true).map{|x| x.update(is_inside: false)}
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


  
  private 
    def validate_type_of_control
      toc_value = Types::Enums::TypeOfControl.values.map{|x| x[1].value}
      toc  = self.type_of_control
      unless toc_value.include? toc
        self.errors.add(:type_of_control, :type_of_control_invalid,
          message: "does not exist")
      end
    end
    
    def validate_frequency
      freq_value = Types::Enums::Frequency.values.map{|x| x[1].value}
      freq = self.frequency
      unless freq_value.include? freq
        self.errors.add(:frequency, :frequency_invalid,
          message: "does not exist")
      end
    end

    def validate_nature
      nat_value = Types::Enums::Nature.values.map{|x| x[1].value}
      nat  = self.nature
      unless nat_value.include? nat
        self.errors.add(:nature, :nature_invalid,
          message: "does not exist")
      end
    end

    def validate_assertion
      asserto_value = Types::Enums::Assertion.values.map{|x| x[1].value}
      asserto  = self.assertion
      asserto.each do |assert|
        unless asserto_value.include? assert
          self.errors.add(:assertion, :assertion_invalid,
            message: "does not exist")
        end
      end
    end

    def validate_ipo
      ip_value = Types::Enums::Ipo.values.map{|x| x[1].value}
      ip  = self.ipo
      ip.each do |i|
        unless ip_value.include? i
          self.errors.add(:ipo, :ipo_invalid,
            message: "does not exist")
        end
      end
    end
end