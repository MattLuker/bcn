class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:index, :show, :edit, :update, :destroy, :merge_user]

  def index
    unless current_user.admin?
      redirect_to home_path
    end
    @users = User.all
  end

  def show
  end

  # GET /users/new
  def new
    if current_user
      redirect_to home_path
    end
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    if not current_user == @user
      flash[:error] = 'You can only update your profile.'
      redirect_to '/users/' + @user.id.to_s
    end
  end

  # Get /user_merge
  def send_merge_email
    merge_user = User.find_by(email: params[:email])

    if merge_user.facebook_id.nil? or merge_user.twitter_id.nil?
      merge_user.generate_user_merge_token!
      Notifier.send_merge(merge_user).deliver_now
      flash[:success] = 'Merge request sent! Please check your email.'
      redirect_to current_user
    else
      flash[:alert] = 'Cannot request merge for this email.'
      redirect_to current_user
    end
  end

  def merge_user
    @user = User.find_by(merge_token: params[:format])

    @user.first_name = current_user.first_name if @user.first_name.nil?
    @user.last_name = current_user.last_name if @user.last_name.nil?
    @user.facebook_id = current_user.facebook_id if @user.facebook_id.nil?
    @user.twitter_id = current_user.twitter_id if @user.twitter_id.nil?
    @user.google_id = current_user.google_id if @user.google_id.nil?
    @user.facebook_link = current_user.facebook_link if @user.facebook_link.nil?
    @user.twitter_link = current_user.twitter_link if @user.twitter_link.nil?
    @user.google_link = current_user.google_link if @user.google_link.nil?
    @user.merge_token = nil

    if @user.save
      # Update all posts.
      current_user.posts.each do |post|
        post.user = @user
        post.save
      end

      # Update all communities created_by.
      Community.where(created_by: current_user.id).each do |community|
        community.created_by = @user.id
        community.save
      end

      # Set the username here since it has to be unique.
      username = current_user.username
      current_user.really_destroy!
      @user.username = username if @user.username.nil?
      @user.save

      session[:user_id] = nil
      reset_session
      flash[:notice] = 'Your account has been merged, please login again.'
      redirect_to home_path
    else
      flash[:alert] = "There was a problem merging your account: #{@user.errors.full_messages[0]}"
      redirect_to current_user
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to home_path, notice: 'Welcome you have successfully registered.'
    else
      render :new
    end
  end

  def update
    if current_user == @user
      if @user.update(user_params)
          flash[:success] = 'Profile successfully updated.'
          redirect_to @user
      else
        render :edit
      end
    elsif current_user.admin?
      if @user.update(user_params)
        flash[:success] = 'User successfully updated.'
        redirect_to users_path
      else
        flash[:success] = 'Problem updating user.'
        redirect_to users_path
      end
    else
      flash[:alert] = 'You can only update your profile.'
      redirect_to '/users/' + @user.id.to_s
    end
  end

  def destroy
    if current_user == @user
      @user.destroy
      redirect_to users_url, notice: 'User was successfully destroyed.'
    elsif current_user.admin?
      @user.destroy
      redirect_to users_url, notice: 'User was successfully destroyed.'
    else
      flash[:error] = 'You can only delete your account.'
      redirect_to '/users/' + @user.id.to_s
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :username, :web_link, :photo, :role)
    end
end
