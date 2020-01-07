class PolicyCategory < ApplicationRecord
    validates :name, uniqueness: true
    has_many :policies
end
