class UserSessionsController < ApplicationController

  def new
    if current_user
      redirect_to home_path
    end
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id

      message = "Welcome #{user.username}"
      if user.first_name
        message = "Welcome #{user.first_name}"
      end

      flash[:success] = message
      redirect_to home_path
    else
      flash[:alert] = 'There was a problem logging in, please check you username and password.'
      render action: 'new'
    end
  end

  def facebook_login

    @facebook = User.facebook(request.env['omniauth.auth']['credentials'])

    fb_user = @facebook.get_object("me?fields=id,name,picture,first_name,last_name,link")
    user = User.find_by(facebook_id: fb_user['id']) unless fb_user['id'].nil?

    # Save the access token for later.
    user.facebook_token = @facebook.access_token if user

    if user.nil?
      user = User.new({facebook_id: fb_user['id'],
                facebook_link: fb_user['link'],
                first_name: fb_user['first_name'],
                last_name: fb_user['last_name'],
                password: (0...50).map { ('a'..'z').to_a[rand(26)] }.join
               })
      if user.save
        flash[:success] = "Welcome #{user.first_name}, you have been registered using Facebook."
        session[:user_id] = user.id
        FacebookSyncJob.perform_now(@facebook.access_token, user)
      else
        user = User.only_deleted.find_by(facebook_id: fb_user['id'])
        User.restore(user)
        user.photo_url = fb_user['picture']['data']['url']
        user.password = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
        user.save

        flash[:success] = 'Welcome back, you have been re-enabled using Facebook.'
        session[:user_id] = user.id
        FacebookSyncJob.perform_now(@facebook.access_token, user)
      end

    else
      if user.photo.nil?
        user.photo_url = fb_user['picture']['data']['url']
        user.save
      end
      flash[:success] = "Welcome #{user.first_name}"
      session[:user_id] = user.id
      FacebookSyncJob.perform_now(@facebook.access_token, user)
    end

    redirect_to home_path
  end

  def twitter_login
    user = User.twitter(request.env['omniauth.auth'])
    session[:user_id] = user.id
    flash[:success] = "Welcome #{user.first_name}"
    redirect_to home_path
  end

  def google_login
    user = User.google(request.env['omniauth.auth'])
    session[:user_id] = user.id
    flash[:success] = "Welcome #{user.first_name}"
    redirect_to home_path
  end

  def auth_failure
    flash[:alert] = 'Authentication failure.'
    redirect_to home_path
  end

  def destroy
    #current_user.event_sync_time = nil unless current_user.event_sync_time.nil?
    #current_user.save
    session[:user_id] = nil
    reset_session
    flash[:notice] = 'You have been logged out.'
    redirect_to home_path
  end
end
