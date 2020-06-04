class Department < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :control_departments, dependent: :destroy
  has_many :controls, through: :control_departments
end
