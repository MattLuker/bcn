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
    @events = Post.where(['start_date = ? or start_date > ?', DateTime.now, DateTime.now]).limit(7)
  end

  def who_we_are
  end

  def calendar
  end

  def help
  end

  def contact
  end

  def send_contact
    puts "params: #{params}"
    unless params[:name].blank?
      redirect_to home_path
    else
      begin
        user = User.find_by_email(params[:email]) if params[:email]
      rescue
        user = nil
      end
      ContactMailer.send_message(user, params[:email], params[:message]).deliver_now
      flash[:success] = 'Thank you for contacting with us, we will get back to you as soon as we can.'
      redirect_to home_path
    end
  end
end
