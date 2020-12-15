class Policy < ApplicationRecord
  validates :title, uniqueness: true
  validates_uniqueness_of :title, :case_sensitive => false
  has_paper_trail ignore: [:visit, :recent_visit, :updated_at]
  has_drafts
  belongs_to :policy_category, optional: true
  belongs_to :user, optional: true
  has_many :policy_resources, dependent: :destroy
  has_many :policy_business_processes, dependent: :destroy
  has_many :policy_it_systems, class_name: "PolicyItSystem", foreign_key: "policy_id", dependent: :destroy
  has_many :resources, through: :policy_resources
  has_many :it_systems, through: :policy_it_systems
  has_many :business_processes, through: :policy_business_processes
  has_many :request_edits, class_name: "RequestEdit", as: :originator, dependent: :destroy
  has_ancestry
  has_many :policy_references, dependent: :destroy
  has_many :references, through: :policy_references
  has_many :policy_controls, dependent: :destroy
  has_many :controls, through: :policy_controls
  has_many :policy_risks, dependent: :destroy
  has_many :risks, through: :policy_risks
  has_many :bookmark_policies, dependent: :destroy
  has_many :users, as: :versions
  has_many :bookmarks, class_name: "Bookmark", as: :originator, dependent: :destroy
  has_many :file_attachments, class_name: "FileAttachment", as: :originator, dependent: :destroy
  belongs_to :user_reviewer, class_name: "User", foreign_key:"user_reviewer_id", optional: true

  after_save :touch_policy_category

  scope :released, -> {where(status: ["release", "ready_for_edit"])}

  def to_humanize
    "#{self.title.capitalize}"
  end

  def request_edit
    request_edits.last
  end

  def touch_policy_category
    if saved_change_to_policy_category_id? && policy_category.present?
      policy_category.update_columns(policy: policy_category.policies.map(&:title))
    end
  end
end