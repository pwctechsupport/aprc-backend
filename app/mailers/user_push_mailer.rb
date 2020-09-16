class UserPushMailer < ApplicationMailer
  default :from => 'noreply.notagain@gmail.com'

  def push_notif_email(user)
    @user = user
    @root_url = "#{ActionMailer::Base.default_url_options[:protocol]}://#{ActionMailer::Base.default_url_options[:host]}"
    if @user.notifications.last.data_type == "related_reference"
      ref_name = @user.notifications.last.title.split(" ")
      ref_include= ref_name.map{|x| x&.include?"#"}
      ref_index = ref_include&.find_index(true)
      reference = ref_name[ref_index]
      mail( :to => @user.email, :subject => "Policies under #{reference} has been updated" )
    else
      mail( :to => @user.email, :subject => "PWC Push Notification | #{@user.notifications.last.body}" )
    end
  end
end
