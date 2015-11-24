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
    case params[:events]
    when 'today'
      today = DateTime.now
      @events = Post.where(['start_date between ? and ?', today.beginning_of_day, today.end_of_day]).order(:start_date).limit(7)
    when 'tomorrow'
      tomorrow = DateTime.now + 1
      @events = Post.where(['start_date between ? and ?', tomorrow.beginning_of_day, tomorrow.end_of_day]).order(:start_date).limit(7)
    when 'next_week'
      @events = Post.where(start_date: Time.now.next_week..Time.now.next_week.end_of_week).order(:start_date).limit(7)
    else
      @events = Post.where(['start_date = ? or start_date > ?', DateTime.now, DateTime.now]).order(:start_date).limit(7)
    end
  end

  def about
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
