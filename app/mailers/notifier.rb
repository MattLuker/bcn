class Notifier < ApplicationMailer
  default_url_options[:host] = "localhost:3000"
  default from: 'adam@thehoick.com'

  def password_reset(user)
    @user = user
    mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "Reset Your Password")
  end

  def user_merge(user, current_user)
    @user = user
    mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "Merge Account Request")
  end
end
