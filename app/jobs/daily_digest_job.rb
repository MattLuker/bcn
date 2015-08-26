class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    users = User.where(notify_daily: true)

    todays_posts = Post.where("created_at >= ?", Time.zone.now.beginning_of_day)
    upcoming_posts = Post.where("start_date >= ?", Date.tomorrow)

    users.each do |user|
      PostMailer.daily_digest(user, todays_posts, upcoming_posts).deliver_now
    end
  end
end