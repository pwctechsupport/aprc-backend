class Risk < ApplicationRecord
  validates :name, uniqueness: true
  has_paper_trail
  has_drafts
  has_many :control_risks, class_name: "ControlRisk", foreign_key: "risk_id", dependent: :destroy
  has_many :controls, through: :control_risks
  has_many :policy_risks, dependent: :destroy
  has_many :policies, through: :policy_risks
  belongs_to :business_process, optional: true
  belongs_to :user, optional: true
  has_many :bookmark_risks
  has_many :users, through: :bookmark_risks
  has_many :bookmarks, class_name: "Bookmark", as: :originator, dependent: :destroy
  belongs_to :user_reviewer, class_name: "User", foreign_key:"user_reviewer_id", optional: true

  def to_humanize
    "#{self.name} : #{self.status}"
  end
end