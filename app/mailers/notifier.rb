class Notifier < ApplicationMailer
  default_url_options[:host] = "localhost:3000"
  default from: 'adam@thehoick.com'

  def password_reset(user)
    @user = user
    mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "Reset Your Password")
  end

  def send_merge(merge_user)
    @user = merge_user
    mail(to: "#{@user.first_name} #{@user.last_name} <#{@user.email}>", subject: "Merge Account Request")
  end
end
