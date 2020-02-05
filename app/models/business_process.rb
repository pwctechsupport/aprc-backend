class BusinessProcess < ApplicationRecord
  has_paper_trail
  validates :name, uniqueness: true
  has_many :policy_business_processes, dependent: :destroy
  has_many :policies, through: :policy_business_processes
  has_many :control_business_processes, dependent: :destroy
  has_many :controls, through: :control_business_processes
  has_ancestry
  has_many :resources, dependent: :destroy
  has_many :risks, dependent: :destroy
  has_many :bookmark_business_processes
  has_many :users, through: :bookmark_business_processes
  has_many :bookmarks, class_name: "Bookmark", as: :originator, dependent: :destroy

  def to_humanize
    "#{self.name} : #{self.status}"
  end
end
