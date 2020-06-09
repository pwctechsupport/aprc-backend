class PolicyCategory < ApplicationRecord
	has_paper_trail on: []

  # Add callbacks in the order you need.
  paper_trail.on_destroy    # add destroy callback
  paper_trail.on_update     # etc.
  paper_trail.on_create
  paper_trail.on_touch
  has_drafts

  serialize :policy, Array
	
	validates :name, uniqueness: true
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

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    allowed_attributes = ["name", "related policy", "related policy title"]
    header = spreadsheet.row(1)
    polcat_names = []
    pol_ids = []
    index_polcat = 0
    (2..spreadsheet.last_row).each do |k|
      row = Hash[[header, spreadsheet.row(k)].transpose]
      if row["name"].present? && !PolicyCategory.find_by_name(row["name"]).present?
        if polcat_names.count != 0
          polcat_obj = PolicyCategory&.find_by_name(polcat_names[index_polcat-1])
          policy_category_id = polcat_obj.update(policy_ids: pol_ids.uniq)
          if polcat_obj&.policies.present?
            polcat_pol = polcat_obj&.policies&.map{|x| x.title}
            polcat_obj&.update(policy: polcat_pol)
          end
          pol_ids.reject!{|x| x == x}
        end
        if !PolicyCategory.find_by_name(row["name"]).present?
          polcat_names.push(row["name"])
        end
        policy_category_id = PolicyCategory&.create(name: polcat_names[index_polcat],policy_ids: row["related policy"], status: "release")
        index_polcat+=1
      end
      if !row["related policy"].nil?
        pol_ids.push(row["related policy"])
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
