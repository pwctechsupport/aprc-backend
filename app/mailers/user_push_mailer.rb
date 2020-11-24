class UserPushMailer < ApplicationMailer
  default :from => 'APRC Tools <Aprc_tools@hotmail.com>'

  def push_notif_email(user, notification)
    @user = user
    @root_url = "#{ActionMailer::Base.default_url_options[:protocol]}://#{ActionMailer::Base.default_url_options[:host]}"
    if notification&.data_type == "related_reference"
      ref_name = notification.title.split(" ")
      ref_include= ref_name.map{|x| x&.include?"#"}
      ref_index = ref_include&.find_index(true)
      reference = ref_name[ref_index]
      mail( :to => @user.email, :subject => "Policies under #{reference} has been updated" )
    else
      mail( :to => @user.email, :subject => "PWC Push Notification | #{@user.notifications.last.body}" )
    end
  end
end
