class ControlDepartment < ApplicationRecord

  # has_paper_trail on: []

  # # Add callbacks in the order you need.
  # paper_trail.on_destroy    # add destroy callback
  # paper_trail.on_update     # etc.
  # paper_trail.on_create
  # paper_trail.on_touch



  belongs_to :control
  belongs_to :department

  before_destroy :update_control_owner

  def update_control_owner
    con_dep = control&.departments&.map{|x| x.name}
    control&.update(control_owner: con_dep)
  end

  def to_humanize
    "#{self.control&.description} : #{self.department.name}"
  end
end
