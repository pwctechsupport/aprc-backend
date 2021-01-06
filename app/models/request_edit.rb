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

  def last_updated_by_user_id
    self&.user_id
  end

  def to_name
    if self.originator_type == "Policy"
      self&.originator&.title
    elsif self.originator_type == "Control"
      self&.originator&.description
    else
      self&.originator&.name
    end
  end
end
