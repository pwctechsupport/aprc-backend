class Department < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :control_departments, dependent: :destroy
  has_many :controls, through: :control_departments

  after_update :update_control_owner

  def update_control_owner
    self.controls.each do |control|
      con_dep = control&.departments&.map{|x| x.name}
      control&.update(control_owner: con_dep)
    end 
  end
end
