class PostMailer < ApplicationMailer
  default_url_options[:host] = "localhost:3000"
  default from: 'robot@boonecommunitynetwork.com'

  def new_post(user, post, community, poster)
    @user = user
    @post = post
    @community = community
    @poster = poster
    mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "New post in #{@community.name}")
  end
end
