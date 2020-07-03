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
    allowed_attributes = ["name", "related policy title"]
    header = spreadsheet.row(1)
    ref_names = []
    pol_ids = []
    pol_obj = []
    error_data = []
    index_ref = 0
    ActiveRecord::Base.transaction do
      (2..spreadsheet.last_row).each do |k|
        row = Hash[[header, spreadsheet.row(k)].transpose]
        if row["name"].present? && !Reference.find_by_name(row["name"]).present?
          if ref_names.count != 0
            reference_id = Reference&.find_by_name(ref_names[index_ref-1]).update(policy_ids: pol_ids.uniq)
            pol_ids.reject!{|x| x == x}
            pol_obj.reject!{|x| x == x}
          end
          lovar= row["name"].count "#"
          if lovar >= 1
            refa= row["name"].gsub('#','')
            refu = '#' << refa 
          elsif lovar < 1
            refu = '#' << row["name"] 
          end
          if !Reference.find_by_name(refu).present?
            ref_names.push(refu)
          end
          reference_id = Reference&.create(name: ref_names[index_ref],policy_ids: Policy.find_by(title: row["related policy title"])&.id, is_inside: true)
          unless reference_id.valid?
            error_data.push({message: reference_id.errors.full_messages.join(","), line: k})
          end
          index_ref+=1
        elsif !row["name"].present?
          error_data.push({message: "Reference name must Exist", line: k})
        end

        reference_inside = Reference.find_by_name(row["name"])
        if row["name"].present? && reference_inside.present?
          if !reference_inside.is_inside?
            error_data.push({message: "Reference data exist, cannot edit Reference named  #{reference_inside&.name }. please remove it from the worksheet", line: k})
          end
        end

        if reference_inside.present?
          if reference_inside&.is_inside?
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

            if k == spreadsheet.last_row && Reference.find_by_name(row["name"]).present?
              if row["name"].present?
                if ref_names.count != 0
                  reference_id = Reference&.find_by_name(ref_names[index_ref-1]).update(policy_ids: pol_ids.uniq)
                  pol_ids.reject!{|x| x == x}
                end
              end
            end
          end
        end
      end

      if error_data.count != 0
        raise ActiveRecord::Rollback, "Rollback Completed"
      end

      if Reference.where(is_inside: true).present?
        Reference.where(is_inside:true).map{|x| x.update(is_inside: false)}
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
