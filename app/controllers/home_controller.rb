class HomeController < ApplicationController
  def index
  end

  def home
    @posts = Post.where(start_date: nil).order('created_at DESC').all.limit(5)
    # @communities = Community.all.popularity.limit(15)
    @communities = []
    @posts.each do |post|
      puts "post.communities.length: #{post.communities.length}, locations.length: #{post.locations.length}"
      if post.locations.length > 0 && post.communities.length > 0
        puts "post.communities.blank?: #{post.communities.blank?}, locations.blank?: #{post.locations.blank?}"

        post.communities.each { |c| @communities.push(c) }
      end
    end
    puts
    puts "@communities: #{@communities.inspect}"
    puts
    @events = Post.where(['start_date = ? or start_date > ?', DateTime.now, DateTime.now]).limit(5)
  end

  def who_we_are
  end

  def calendar
  end
end
