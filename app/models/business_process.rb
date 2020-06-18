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
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      bp_obj.push({name: row["name"], sub1: row["sub business process 1"], sub2: row["sub business process 2"]})
      bp_obj.each do |bp|
        if bp[:name].present?
          main_bp = BusinessProcess.find_by_name(bp[:name])
          if !main_bp.present?
            main_bp = BusinessProcess.create(name: bp[:name])
          end
          if bp[:sub1].present?
            bispro = BusinessProcess.find_by_name(bp[:sub1])
            if bispro.present?
              if bp[:sub2].present?
                BusinessProcess.create(name:bp[:sub2], parent_id: bispro&.id)
              end
            else
              bispro = BusinessProcess.create(name:bp[:sub1], parent_id:main_bp&.id)
              if bp[:sub2].present?
                BusinessProcess.create(name:bp[:sub2], parent_id: bispro&.id)
              end
            end
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
end


# if row["sub business process 1"].present?
#   business_process_id = business_process_id&.id
#   sub_business_process = BusinessProcess.create(name: row["sub business process 1"], parent_id: business_process_id)
#   if row["sub business process 2"].present?
#     sub_business_process_id = sub_business_process&.id
#     second_sub_business_process = BusinessProcess.create(name: row["sub business process 2"], parent_id: sub_business_process_id)
#   end
# end