class UserSessionsController < ApplicationController
  def new
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
      flash[:error] = 'There was a problem logging in, please check you username and password.'
      render action: 'new'
    end
  end

  def facebook_login
    fb_user = User.koala(request.env['omniauth.auth']['credentials'])
    puts fb_user.inspect

    user = User.find_by(facebook_id: fb_user['id']) unless fb_user['id'].nil?

    if user.nil?
      puts 'Creating user...'
      user = User.create({facebook_id: fb_user['id'],
                          username: "#{fb_user['first_name'].downcase}.#{fb_user['last_name'].downcase}_fb",
                          first_name: fb_user['first_name'],
                          last_name: fb_user['last_name'],
                          photo: fb_user['picture']['data']['url'],
                          password: (0...50).map { ('a'..'z').to_a[rand(26)] }.join
                         })
      puts "user.facebook_id: #{user.facebook_id}, fb_user['id']: #{fb_user['id']}"
      puts "user.errors: #{user.errors.full_messages[0]}"
      session[:user_id] = user.id
    else
      session[:user_id] = user.id
    end

    redirect_to home_path
  end

  def destroy
    session[:user_id] = nil
    reset_session
    flash[:notice] = 'You have been logged out.'
    redirect_to home_path
  end
end
