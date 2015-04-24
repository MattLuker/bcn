module Api
  class ApiController < ApplicationController
    skip_before_filter :verify_authenticity_token
    protect_from_forgery with: :null_session
    #helper_method :authenticate
    helper_method :current_user

    def current_user
      @current_user
    end

    def authenticate
      if not session[:user_id]
        basic_auth
      end
    end

    def basic_auth
      authenticate_or_request_with_http_basic do |email, password|
        #authenticate_with_http_basic do |email, password|

        Rails.logger.info "API authentication: #{email}, #{password}"
        user = User.find_by(email: email)

        if user && user.authenticate(password)
          @current_user = user
          Rails.logger.info "Logging in #{user.inspect}"
          true
        else
          Rails.logger.info "Credentials invalid."
          # Send HTTP status for 401.
          false
        end
      end
    end
  end
end