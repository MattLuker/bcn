class ContactMailer < ApplicationMailer
  default_url_options[:host] = "bcn.thehoick.com"
  default from: 'robot@boonecommunitynetwork.com'

  def send_message(user, email, message)
    @user = user
    @email = email
    @message = message
    mail(to: "Adam Somer <asommer70@gmail.com>", subject: "New Contact Message from BCN")
  end
end