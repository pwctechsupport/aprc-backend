class Notification < ApplicationRecord
  belongs_to :user, optional: true
  serialize :data
  belongs_to :originator, polymorphic: true
  belongs_to :sender_user, class_name:"User", foreign_key:"sender_user_id", optional: true

  def self.send_notification(arr_of_user, title, body, originator,sender_user_id)
    arr_of_user.each do |user|
      Notification.create(user_id: user&.to_i, title: title, body: body , originator: originator, data: originator.to_json, sender_user_id: sender_user_id)
    end
  end
end
