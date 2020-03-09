class UserPushMailer < ApplicationMailer
  default :from => 'pwcrubyhuser@gmail.com'

  def push_notif_email(user)
    @user = user
    mail( :to => @user.email,
    :subject => "PWC Push Notification | #{@user.notifications.last.body}" )
  end
end
