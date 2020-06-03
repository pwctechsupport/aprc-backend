class UserResourceVisit < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :resource, optional: true
end
