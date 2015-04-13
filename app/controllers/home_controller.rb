class HomeController < ApplicationController
  def index

  end

  def home
    @posts = Post.all.limit(5)
    @communities = Community.all
  end

  def who_we_are

  end

  def calendar

  end
end
