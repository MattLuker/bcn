module Api
  class ApiController < ApplicationController
    skip_before_filter :verify_authenticity_token
    protect_from_forgery with: :null_session
    helper_method :current_user

    def current_user
      @current_user
    end

    def authenticate
      if not session[:user_id]
        # Perform basic auth for Post create, or not.
        if controller_name == 'posts' and action_name == 'create'
          if request.headers.include?('HTTP_AUTHORIZATION')
            basic_auth
          else
            true
          end
        else
          basic_auth
        end
      end
    end

    def basic_auth
      authenticate_or_request_with_http_basic do |email, password|
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