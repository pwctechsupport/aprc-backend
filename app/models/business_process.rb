class BusinessProcess < ApplicationRecord
  has_paper_trail
  validates :name, uniqueness: true
  validates_uniqueness_of :name, :case_sensitive => false

  has_many :policy_business_processes, dependent: :destroy
  has_many :policies, through: :policy_business_processes
  has_many :control_business_processes, dependent: :destroy
  has_many :controls, through: :control_business_processes
  has_many :risk_business_processes, dependent: :destroy
  has_many :risks, through: :risk_business_processes
  accepts_nested_attributes_for :risks, allow_destroy: true
  has_ancestry
  has_many :resources, dependent: :nullify
  has_many :bookmark_business_processes
  has_many :users, through: :bookmark_business_processes
  has_many :bookmarks, class_name: "Bookmark", as: :originator, dependent: :destroy
  has_many :tags, dependent: :destroy


  def to_humanize
    "#{self.name} : #{self.status}"
  end

  def self.import(file, current_user=nil)
    spreadsheet = open_spreadsheet(file)
    allowed_attributes = ["name", "sub business process 1", "sub business process 2"]
    header = spreadsheet.row(1)
    if header.present?
      header.map! {|x| x.downcase}
    end
    bp_obj = []
    collected_bp =[]
    error_data =[]
    spread_count = spreadsheet.row(2).count
    spread_nil = spreadsheet.row(2).group_by(&:itself).map { |k,v| [k, v.length] }.to_h
    if spread_nil[nil] == spread_count
      error_data.push({message: "Business Process cannot be empty", line: 2})
    end
    
    ActiveRecord::Base.transaction do 
      (2..spreadsheet.last_row).each do |k|
        row = Hash[[header, spreadsheet.row(k)].transpose]
        if !header.present?
          error_data.push({message: "Business Process Headers does not exist", line: 1})
        end
        if header.sort != allowed_attributes.sort
          error_data.push({message: "Incorrect Header, Please follow the existing template", line: 1})
        end
        if !row["name"].present?
          error_data.push({message: "Business Process Must Exist", line: k})
        end
        bp_obj.push({name: row["name"], sub1: row["sub business process 1"], sub2: row["sub business process 2"]})
        bp_obj.each do |bp|
          if bp[:name].present?
            main_bp = BusinessProcess.find_by_name(bp[:name])
            if !main_bp.present?
              main_bp = BusinessProcess.create(name: bp[:name], created_by: current_user&.name, last_updated_by: current_user&.name)
              unless main_bp.valid?
                error_data.push({message: main_bp.errors.full_messages.join(","), line: k})
              else
                collected_bp.push(main_bp&.id)
              end
            else
              error_data.push({message: "Business Process already Existed", line: k})
            end
            if bp[:sub1].present?
              bispro = BusinessProcess.find_by_name(bp[:sub1])
              if bispro.present?
                if bispro&.parent_id.present?
                  if bispro.parent_id == main_bp&.id
                    if bp[:sub2].present?
                      bispro_2 = BusinessProcess.find_by_name(bp[:sub2]) 
                      if !bispro_2.present?
                        bispro_2 = BusinessProcess.create(name:bp[:sub2], parent_id: bispro&.id)
                        unless bispro_2.valid?
                          error_data.push({message: bispro_2.errors.full_messages.join(","), line: k})
                        else
                          collected_bp.push(bispro_2&.id)
                        end
                      else 
                        if bispro_2.parent_id.present?
                          if bispro_2&.parent_id != bispro&.id
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
                bispro = BusinessProcess.create(name:bp[:sub1], parent_id:main_bp&.id, created_by: current_user&.name, last_updated_by: current_user&.name)
                unless bispro.valid?
                  error_data.push({message: bispro.errors.full_messages.join(","), line: k})
                else
                  collected_bp.push(bispro&.id)
                end
                if bp[:sub2].present?
                  bispro_2 = BusinessProcess.find_by_name(bp[:sub2]) 
                  if !bispro_2.present?
                    bispro_2 = BusinessProcess.create(name:bp[:sub2], parent_id: bispro&.id)
                    unless bispro_2.valid?
                      error_data.push({message: bispro_2.errors.full_messages.join(","), line: k})
                    else
                      collected_bp.push(bispro_2&.id)
                    end
                  else 
                    if bispro_2.parent_id.present?
                      if bispro_2&.parent_id != bispro&.id
                        error_data.push({message: "Sub Business Process 2 belongs to another parent", line: k})
                      end
                    else
                      bispro_2.update(parent_id: bispro&.id)
                    end
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
      end
      if error_data.count != 0
        raise ActiveRecord::Rollback, "Rollback Completed"
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
end

