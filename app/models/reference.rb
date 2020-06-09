class Reference < ApplicationRecord
  validates :name, uniqueness: true
  has_paper_trail
  has_many :policy_references, dependent: :destroy
  has_many :policies, through: :policy_references
  accepts_nested_attributes_for :policies, allow_destroy: true
  def to_humanize
    "#{self.name} : #{self.status}"
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    allowed_attributes = ["name", "related policy", "related policy title"]
    header = spreadsheet.row(1)
    ref_names = []
    ref_ids = []
    index_ref = 0
    (2..spreadsheet.last_row).each do |k|
      row = Hash[[header, spreadsheet.row(k)].transpose]
      if row["name"].present? && !Reference.find_by_name(row["name"]).present?
        if ref_names.count != 0
          reference_id = Reference&.find_by_name(ref_names[index_ref-1]).update(policy_ids: ref_ids.uniq)
          ref_ids.reject!{|x| x == x}
        end
        lovar= row["name"].count "#"
        if lovar >= 1
          refa= row["name"].gsub('#','')
          refu = '#' << refa 
          if !Reference.find_by_name(refu).present?
            ref_names.push(refu)
          end
          reference_id = Reference&.create(name: ref_names[index_ref],policy_ids: row["related policy"])
        elsif lovar < 1
          refu = '#' << row["name"] 
          if !Reference.find_by_name(refu).present?
            ref_names.push(refu)
          end
          reference_id = Reference&.create(name: ref_names[index_ref],policy_ids: row["related policy"])
        else
          if !Reference.find_by_name(row["name"]).present?
            ref_names.push(row["name"])
          end
        end
        index_ref+=1
      end
      ref_ids.push(row["related policy"])
      if k == spreadsheet.last_row && Reference.find_by_name(row["name"]).present?
        if row["name"].present?
          if ref_names.count != 0
            reference_id = Reference&.find_by_name(ref_names[index_ref-1]).update(policy_ids: ref_ids.uniq)
            ref_ids.reject!{|x| x == x}
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
