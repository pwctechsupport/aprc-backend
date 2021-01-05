class MailerPreviews
  class NotificationPreview < ActionMailer::Preview
    def push_notif_email
      notification = Notification.find 1203
      user = notification.user
      UserPushMailer.push_notif_email(user, notification)
    end

  end
end

