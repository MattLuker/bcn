class ApplyBadgesJob < ActiveJob::Base

  queue_as :default

  def perform(user)
    Badge.all.each do |badge|
      if eval(badge.rules)
        unless badge.users.include?(user)
          badge.users << user
        end
      end
    end
  end

end