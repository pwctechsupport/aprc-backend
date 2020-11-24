class MailerPreviews
  class NotificationPreview < ActionMailer::Preview
    def push_notif_email
      user = User.find 16
      UserPushMailer.push_notif_email(user)
    end

  end
end

