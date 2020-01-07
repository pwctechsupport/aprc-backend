class Reference < ApplicationRecord
  validates :name, uniqueness: true
  has_many :policy_references
  has_many :policies, through: :policy_references
end
