class BusinessProcess < ApplicationRecord
  has_paper_trail
  validates :name, uniqueness: true
  has_many :policy_business_processes, dependent: :destroy
  has_many :policies, through: :policy_business_processes
  has_many :control_business_processes, dependent: :destroy
  has_many :controls, through: :control_business_processes
  has_many :risk_business_processes, dependent: :destroy
  has_many :risks, through: :risk_business_processes
  accepts_nested_attributes_for :risks, allow_destroy: true
  has_ancestry
  has_many :resources, dependent: :destroy
  has_many :bookmark_business_processes
  has_many :users, through: :bookmark_business_processes
  has_many :bookmarks, class_name: "Bookmark", as: :originator, dependent: :destroy
  has_many :tags, dependent: :destroy


  def to_humanize
    "#{self.name} : #{self.status}"
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    allowed_attributes = ["name", "sub business process 1", "sub business process 2"]
    header = spreadsheet.row(1)
    bp_obj = []
    collected_bp =[]
    error_data =[]
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      bp_obj.push({name: row["name"], sub1: row["sub business process 1"], sub2: row["sub business process 2"]})
      bp_obj.each do |bp|
        if bp[:name].present?
          main_bp = BusinessProcess.find_by_name(bp[:name])
          if !main_bp.present?
            main_bp = BusinessProcess.create(name: bp[:name])
            unless main_bp.valid?
              error_data.push({message: main_bp.errors.full_messages.join(","), line: k})
            else
              collected_bp.push(main_bp&.id)
            end
          end
          if bp[:sub1].present?
            bispro = BusinessProcess.find_by_name(bp[:sub1])
            if bispro.present?
              if bp[:sub2].present?
                bispro_2 = BusinessProcess.find_by_name(bp[:sub2]) 
                if !bispro_2.present?
                  bispro_2 = BusinessProcess.create(name:bp[:sub2], parent_id: bispro&.id)
                  unless bispro_2.valid?
                    error_data.push({message: bispro_2.errors.full_messages.join(","), line: k})
                  else
                    collected_bp.push(bispro_2&.id)
                  end
                end
              end
            else
              bispro = BusinessProcess.create(name:bp[:sub1], parent_id:main_bp&.id)
              unless bispro.valid?
                error_data.push({message: bispro.errors.full_messages.join(","), line: k})
              else
                collected_bp.push(bispro&.id)
              end
              if bp[:sub2].present?
                bispro_2 = BusinessProcess.create(name:bp[:sub2], parent_id: bispro&.id)
                unless bispro_2.valid?
                  error_data.push({message: bispro_2.errors.full_messages.join(","), line: k})
                else
                  collected_bp.push(bispro_2&.id)
                end
              end
            end
          end
        end
      end
    end
    return true, error_data
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

