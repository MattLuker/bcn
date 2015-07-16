class Notifier < ApplicationMailer
  default_url_options[:host] = "bcn.thehoick.com"
  default from: 'robot@boonecommunitynetwork.com'

  def password_reset(user)
    @user = user
    mail(to: "#{user.first_name if user.first_name} #{user.last_name if user.last_name} <#{user.email}>", subject: "Reset Your Password")
  end

  def send_merge(merge_user)
    @user = merge_user
    mail(to: "#{@user.first_name if @user.first_name} #{@user.last_name if @user.last_name} <#{@user.email}>", subject: "Merge Account Request")
  end

  def send_welcome(user)
    @user = user
    mail(to: "#{@user.first_name if @user.first_name} #{@user.last_name if @user.last_name} <#{@user.email}>",
         subject: "Welcome!")
  end

  def user_join(leader, user, organization)
    @leader = leader
    @user = user
    @organization = organization
    mail(to: "#{@user.first_name if @leader.first_name} #{@leader.last_name if @leader.last_name} <#{@leader.email}>",
         subject: "New member in #{@organization.name}")
  end
end