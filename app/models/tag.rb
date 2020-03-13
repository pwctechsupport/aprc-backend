class Tag < ApplicationRecord
  belongs_to :resource, optional: true
  belongs_to :business_process, optional: true
  belongs_to :user, optional: true
  belongs_to :control, optional: true
  belongs_to :risk, optional:true
end
