class BadgesController < ApplicationController
  def index
    @badges = Badge.all
  end

  def show
  end

  def new
    @badge = Badge.new
  end

  def create
    puts "params: #{params}"
    if @badge = Badge.new(badge_params)
      puts "@badge: #{@badge.inspect}"

      flash[:success] = 'Badge was successfully created.'
      redirect_to @badge
    else
      flash[:success] = 'There was a problem creating the badge.'
      redirect_to new_badge_path
    end
  end

  def update
  end

  private
    def badge_params
      params.require(:badge).permit(:name, :rules, :image);
    end
end