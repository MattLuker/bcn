class BadgesController < ApplicationController
  before_action :find_badge, only: [:show, :edit, :update, :destroy]

  before_filter :require_user, only: [:create, :new, :edit, :update, :destroy]
  before_filter :check_admin, only: [:create, :new, :edit, :update, :destroy]

  def index
    @badges = Badge.all
  end

  def show
    @badge = Badge.find(params[:id])
  end

  def new
    @badge = Badge.new
  end

  def create
    if @badge = Badge.create(badge_params)

      flash[:success] = 'Badge was successfully created.'
      redirect_to @badge
    else
      flash[:success] = 'There was a problem creating the badge.'
      redirect_to new_badge_path
    end
  end

  def edit
  end

  def update
    if @badge.update(badge_params)
      flash[:success] = 'Badge successfully updated.'
      redirect_to @badge
    else
      render :edit
    end
  end

  def destroy
    if @badge.destroy
      flash[:success] = 'Badge deleted.'
      redirect_to badges_path
    else
      flash[:alert] = 'There was a problem deleting the badge.'
      redirect_to @badge
    end
  end

  private
    def find_badge
      @badge = Badge.find(params[:id])
    end

    def check_admin
      unless current_user.admin?
        flash[:error] = 'Page not available.'
        redirect_to badges_path
      end
    end

    def badge_params
      params.require(:badge).permit(:name, :description, :rules, :image);
    end
end