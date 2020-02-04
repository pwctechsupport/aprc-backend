class Reference < ApplicationRecord
  validates :name, uniqueness: true
  has_paper_trail
  has_many :policy_references
  has_many :policies, through: :policy_references
  def to_humanize
    "#{self.name} : #{self.status}"
  end
end
