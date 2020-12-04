class PolicyCategory < ApplicationRecord
	has_paper_trail ignore: [:updated_at, :is_inside]

  # Add callbacks in the order you need.
  paper_trail.on_destroy    # add destroy callback
  paper_trail.on_update     # etc.
  paper_trail.on_create
  paper_trail.on_touch
  has_drafts

  serialize :policy, Array
	
	validates :name, uniqueness: true
  validates_uniqueness_of :name, :case_sensitive => false
  has_many :policies , inverse_of: :policy_category,dependent: :nullify
  accepts_nested_attributes_for :policies, allow_destroy: true
  has_many :user_policy_categories, dependent: :destroy
  has_many :users, through: :user_policy_categories
  belongs_to :user_reviewer, class_name: "User", foreign_key:"user_reviewer_id", optional: true
  has_many :request_edits, class_name: "RequestEdit", as: :originator, dependent: :destroy
  
  def request_edit
    request_edits.last
  end

  def to_humanize
    "#{self.name}"
  end

  def self.import(file, current_user=nil)
    spreadsheet = open_spreadsheet(file)
    allowed_attributes = ["name", "related policy title"]
    header = spreadsheet.row(1)
    if header.present?
      header.map! {|x| x.downcase}
    end
    polcat_names = []
    pol_ids = []
    pol_obj = []
    error_data = []
    index_polcat = 0
    spread_count = spreadsheet.row(2).count
    spread_nil = spreadsheet.row(2).group_by(&:itself).map { |k,v| [k, v.length] }.to_h
    if spread_nil[nil] == spread_count
      error_data.push({message: "Policy Category cannot be empty", line: 2})
    end
    ActiveRecord::Base.transaction do 
      (2..spreadsheet.last_row).each do |k|
        row = Hash[[header, spreadsheet.row(k)].transpose]
        if !header.present?
          error_data.push({message: "Policy Category Headers does not exist", line: 1})
        end
        if header.sort != allowed_attributes.sort
          error_data.push({message: "Incorrect Header, Please follow the existing template", line: 1})
        end
        if row["name"].present? && !PolicyCategory.find_by_name(row["name"]).present?
          if polcat_names.count != 0
            polcat_obj = PolicyCategory&.find_by_name(polcat_names[index_polcat-1])
            if polcat_obj.present?
              policy_category_id = polcat_obj.update(policy_ids: pol_ids.uniq)
              if polcat_obj&.policies.present?
                polcat_pol = polcat_obj&.policies&.map{|x| x.title}
                polcat_obj&.update(policy: polcat_pol)
              end
            end
            pol_ids.reject!{|x| x == x}
            pol_obj.reject!{|x| x == x}
          end

          if !PolicyCategory.find_by_name(row["name"]).present?
            polcat_names.push(row["name"])
          end

          if !Policy.find_by(title: row["related policy title"].to_s).present?
            error_data.push({message: "Policy must Exist", line: k})
          end

          policy_category_id = PolicyCategory&.create(name: polcat_names[index_polcat],policy_ids: Policy.find_by(title: row["related policy title"].to_s)&.id, status: "release", is_inside: true, created_by: current_user&.name, last_updated_by: current_user&.name)

          unless policy_category_id.valid?
            error_data.push({message: policy_category_id.errors.full_messages.join(","), line: k})
          end
          index_polcat+=1

        elsif !row["name"].present?
          error_data.push({message: "Policy Category name must Exist", line: k})
        end

        polcat_inside = PolicyCategory.find_by_name(row["name"])
        if row["name"].present? && polcat_inside.present?
          if !polcat_inside.is_inside?
            error_data.push({message: "Policy Category data already exist, cannot edit Policy Category named  #{polcat_inside&.name }. please remove it from the worksheet", line: k})
          end
        end

        if polcat_inside.present?
          if polcat_inside&.is_inside?
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

            if k == spreadsheet.last_row && PolicyCategory.find_by_name(row["name"]).present?
              if row["name"].present?
                if polcat_names.count != 0
                  polcat_obj = PolicyCategory&.find_by_name(polcat_names[index_polcat-1])
                  policy_category_id = polcat_obj.update(policy_ids: pol_ids.uniq)
                  if polcat_obj&.policies.present?
                    polcat_pol = polcat_obj&.policies&.map{|x| x.title}
                    polcat_obj&.update(policy: polcat_pol)
                  end
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

      if PolicyCategory.where(is_inside: true).present?
        PolicyCategory.where(is_inside:true).map{|x| x.update(is_inside: false)}
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
