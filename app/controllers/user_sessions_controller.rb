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
end
