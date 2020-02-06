class Notification < ApplicationRecord
  belongs_to :user
  serialize :data
  belongs_to :originator, polymorphic: true

  def self.send_notification(arr_of_user, title, body, originator)
    arr_of_user.each do |user|
      Notification.create(user_id: user.to_i, title: title, body: body , originator: originator, data: originator.to_json)
    end
  end
end
