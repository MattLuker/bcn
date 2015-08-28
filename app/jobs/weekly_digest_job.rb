class WeeklyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    users = User.where(notify_weekly: true)

    weeks_posts = Post.where('created_at >= ?', 1.week.ago).limit(24)
    upcoming_posts = Post.where('start_date >= ?', Date.tomorrow).limit(7)

    users.each do |user|
      puts "user.email: #{user.email}"
      PostMailer.weekly_digest(user, weeks_posts, upcoming_posts).deliver_now
    end
  end
end