class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    users = User.where(notify_daily: true)

    todays_posts = Post.where("created_at >= ?", Time.zone.now.beginning_of_day).limit(14)
    upcoming_posts = Post.where("start_date >= ?", Date.tomorrow).limit(7)

    users.each do |user|
      puts "user.email: #{user.email}"
      PostMailer.daily_digest(user, todays_posts, upcoming_posts).deliver_now
    end
  end
end