class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:show, :edit, :update, :destroy, :merge_user]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
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

    if merge_user.facebook_id.nil?
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
    @user.first_name = current_user.first_name
    @user.last_name = current_user.last_name
    @user.username = current_user.username
    @user.facebook_id = current_user.facebook_id
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

      current_user.really_destroy!

      session[:user_id] = nil
      reset_session
      flash[:notice] = 'Your account has been merged, please login again.'
      redirect_to home_path
    else
      flash[:notice] = 'There was a problem merging your account.'
      redirect_to current_user
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if current_user == @user
        if @user.update(user_params)
          format.html {
            flash[:success] = 'Profile successfully updated.'
            redirect_to @user
          }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        flash[:error] = 'You can only update your profile.'
        redirect_to '/users/' + @user.id.to_s
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if current_user == @user
      @user.destroy
      redirect_to users_url, notice: 'User was successfully destroyed.'
    else
      flash[:error] = 'You can only delete your account.'
      redirect_to '/users/' + @user.id.to_s
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :username)
    end
end
