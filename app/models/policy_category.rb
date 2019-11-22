class PolicyCategory < ApplicationRecord
    has_many :policies
    belongs_to :user
end
