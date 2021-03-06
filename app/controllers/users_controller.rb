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
    @posts = @user.posts.order('created_at DESC').paginate(:page => params[:page], :per_page => 5)
  end

  # GET /users/new
  def new
    if current_user
      flash[:success] = 'Welcome you have successfully registered.'
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

      # Remove FacebookSubscriptions.
      FacebookSubscription.where(user_id: current_user.id).each do |sub|
        sub.destroy
      end

      current_user.really_destroy!
      @user.username = username if @user.username.nil?
      @user.save

      session[:user_id] = nil
      reset_session
      flash[:notice] = 'Hurray! Your account setup with email and the new account setup via social network have been merged, you can now login with email or social network accounts.'
      redirect_to login_path
    else
      flash[:alert] = "There was a problem merging your account: #{@user.errors.full_messages[0]}"
      redirect_to current_user
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # Send welcome email.
      Notifier.delay.send_welcome(@user)

      session[:user_id] = @user.id
      flash[:success] = 'Welcome you have successfully registered.'
      redirect_to root_path
    else
      if @user.errors.has_key?(:email)
        flash[:alert] = "Email #{@user.errors.get(:email)[0]}."
        redirect_to new_user_path
      else
        @user = User.only_deleted.find_by(email: user_params[:email])
        if @user
          User.restore(@user)
          @user.password = user_params[:password]
          @user.save

          Notifier.send_welcome(@user).deliver_now
          session[:user_id] = @user.id
          redirect_to home_path, success: 'Welcome you have successfully registered.'
        else
          render :new
        end
      end
    end
  end

  def update
    if current_user == @user
      if @user.update(user_params)
        ApplyBadgesJob.perform_now(current_user)
        flash[:success] = 'Profile successfully updated.'
        redirect_to @user
      else
        puts "user.errors: #{@user.errors.full_messages}"
        if @user.errors[:email].include?('has already been taken')
          flash[:alert] = "Sorry, that email has already been taken. Click ".html_safe +
          " <a href='/send_merge?email=#{@user.email}'><strong>here</strong></a> to merge accounts.".html_safe
        end
        render :edit
      end
    elsif current_user.admin?
      if @user.update(user_params)
        flash[:success] = 'User successfully updated.'
        redirect_to @user
      else
        flash[:alert] = 'Problem updating user.'
        redirect_to :edit
      end
    else
      flash[:alert] = 'You can only update your profile.'
      redirect_to @user
    end
  end

  def destroy
    if current_user == @user
      @user.destroy
      session[:user_id] = nil
      reset_session
      redirect_to home_path, notice: 'User was successfully destroyed.'
    elsif current_user.admin?
      @user.destroy
      session[:user_id] = nil
      reset_session
      redirect_to home_path, notice: 'User was successfully destroyed.'
    else
      flash[:error] = 'You can only delete your account.'
      redirect_to '/users/' + @user.id.to_s
    end
  end

  def add_admin
    if Role.create(user: User.find(params[:user_id]), name: 'admin')
      flash[:success] = 'Admin role added.'
    else
      flash[:error] = 'There was a problem adding the Admin role.'
    end
    redirect_to users_path
  end

  def remove_admin
    user = User.find(params[:user_id])
    role = Role.where(user_id: user.id, name: 'admin')[0]
    if role.destroy
      flash[:success] = 'Admin role removed.'
    else
      flash[:error] = 'There was a problem removing Admin role.'
    end
    redirect_to users_path
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email,
                                 :password, :username, :web_link,
                                 :photo, :role, :bio, :explicit,
                                 :retained_photo, :facebook_link,
                                 :twitter_link, :google_link,
                                 :notify_instant, :notify_daily,
                                 :notify_weekly)
  end
end
