class PostMailer < ApplicationMailer
  default_url_options[:host] = "boonecommunitynetwork.com"
  default from: 'robot@boonecommunitynetwork.com'

  def new_post(user, post, community, poster)
    @user = user
    @post = post
    @community = community
    @poster = poster

    mail(to: "#{user.first_name if @user.first_name} #{user.last_name if @user.last_name} <#{user.email}>",
         subject: "New post in #{@community.name}")

  end

  def post_updated(user, post, poster)
    @user = user
    @post = post
    @poster = poster

    mail(to: "#{user.first_name if @user.first_name} #{user.last_name if @user.last_name} <#{user.email}>",
         subject: "#{@post.title} has been updated.")

  end

  def daily_digest(user, todays, upcoming)
    @user = user
    @todays = todays
    @upcoming = upcoming

    puts "@todays.length: #{@todays.length}"
    puts "@upcoming.length: #{@upcoming.length}"

    mail(to: "#{user.first_name if @user.first_name} #{user.last_name if @user.last_name} <#{user.email}>",
         subject: "Your BCN Daily Digest.")
  end

  def weekly_digest(user, weeks, upcoming)
    @user = user
    @weeks = weeks
    @upcoming = upcoming

    puts "@todays.length: #{@weeks.length}"
    puts "@upcoming.length: #{@weeks.length}"

    mail(to: "#{user.first_name if @user.first_name} #{user.last_name if @user.last_name} <#{user.email}>",
         subject: "Your BCN Weekly Digest.")
  end
end
