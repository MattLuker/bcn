class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  #rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    if current_user
      true
    else
      redirect_to new_user_session_path, notice: 'You must be logged in to view that page.'
    end
  end

  def render_404
    respond_to do |format|
      format.html do
        render file: 'public/404.html', status: :not_found, layout: false
      end
      format.json do
        render status: 404, json: { message: 'Not found.' }
      end
      format.rss do
        render status: 404, xml: '<rss xmlns:atom="http://www.w3.org/2005/Atom" version="2.0"><channel>Not Found</channel></rss>'
      end
    end
  end
end
