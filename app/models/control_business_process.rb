class ControlBusinessProcess < ApplicationRecord
  belongs_to :control
  belongs_to :business_process
end
