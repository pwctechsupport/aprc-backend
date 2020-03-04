class Tag < ApplicationRecord
  belongs_to :resource, optional: true
  belongs_to :business_process, optional: true
  belongs_to :user, optional: true
end
