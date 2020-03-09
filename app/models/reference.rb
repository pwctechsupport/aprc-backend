class Reference < ApplicationRecord
  validates :name, uniqueness: true
  has_paper_trail
  has_many :policy_references
  has_many :policies, through: :policy_references
  accepts_nested_attributes_for :policies, allow_destroy: true
  def to_humanize
    "#{self.name} : #{self.status}"
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    allowed_attributes = ["name", "related policy"]
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      if row["related policy"].class == (Integer || Fixnum || Bignum)
        lovar= row["name"].count "#"
        if lovar >= 1
          refa= row["name"].gsub('#','')
          refu = '#' << refa 
          reference_id = Reference&.create(name: refu,policy_ids: row["related policy"])
        elsif lovar < 1
          refu = '#' << row["name"]
          reference_id = Reference&.create(name: refu,policy_ids: row["related policy"])
        end
      
      else
        lovar= row["name"].count "#"
        if lovar >= 1
          refa= row["name"].gsub('#','')
          refu = '#' << refa 
          reference_id = Reference&.create(name: refu,policy_ids: row["related policy"]&.split("|"))
        elsif lovar < 1
          refu = '#' << row["name"] 
          reference_id = Reference&.create(name: refu,policy_ids: row["related policy"]&.split("|"))
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
