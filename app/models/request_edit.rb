class RequestEdit < ApplicationRecord
  belongs_to :user
  belongs_to :originator, polymorphic: true
  belongs_to :approver, class_name: "User", foreign_key:"approver_id", optional: true


  state_machine :state, initial: :requested do
    event :approve do
      transition to: :approved, from: :requested
    end
    event :reject do
      transition to: :rejected, from: :requested
    end
  end

  def to_name
    if self.originator_type == ("User" && "Risk" && "Resource" && "PolicyCategory")
      self&.originator&.name
    elsif self.originator_type == "Control"
      self&.originator&.description
    else
      self&.originator&.title
    end
  end
end
