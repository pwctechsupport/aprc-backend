class Notification < ApplicationRecord
  after_create :push_notif_email

  belongs_to :user, optional: true
  serialize :data
  belongs_to :originator, polymorphic: true
  belongs_to :sender_user, class_name:"User", foreign_key:"sender_user_id", optional: true

  def push_notif_email
    user = User.find(self.user_id)
    UserPushMailer.push_notif_email(user, self).deliver_later
  end

  def self.send_notification(arr_of_user, title, body, originator,sender_user_id, data_type= nil)
    arr_of_user.each do |user|
      Notification.create(user_id: user&.to_i, title: title, body: body , originator: originator, sender_user_id: sender_user_id, data_type: data_type)
    end
    # if arr_of_user.include? originator&.user_reviewer_id 
    #   Notification.create(user_id: originator.user_reviewer_id, title: title, body: body , originator: originator, sender_user_id: sender_user_id, data_type: data_type)
    # end
  end

  def self.send_notification_to_all(arr_of_user, title, body, originator,sender_user_id, data_type= nil)
    arr_of_user.each do |user|
      Notification.create(user_id: user&.to_i, title: title, body: body , originator: originator, sender_user_id: sender_user_id, data_type: data_type, is_general: true)
    end
  end
end
