class HomeController < ApplicationController
  def index
  end

  def home
    @posts = Post.where(start_date: nil).order('created_at DESC').all.limit(6)
    # @communities = []
    # @posts.each do |post|
    #   if post.locations.length > 0 && post.communities.length > 0
    #     post.communities.each { |c| @communities.push(c) }
    #   end
    # end
    @communities = Community.all
    @events = Post.where(['start_date = ? or start_date > ?', DateTime.now, DateTime.now]).limit(5)
  end

  def who_we_are
  end

  def calendar
  end
end
