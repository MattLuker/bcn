class Api::UsersController < Api::ApiController
  before_filter :authenticate, only: [:index, :show, :update, :destroy]

  def index
    if current_user.nil?
      render status: 401, json: {
                            errors: 'Unauthorized.'
                        }.to_json
    else
      if current_user.role == 'admin'
        users = User.all
        render status: 200, json: users.as_json
      else
        render status: 422, json: {
                              errors: 'Method not allowed.'
                          }.to_json
      end
    end
  end

  def show
    render json: current_user.as_json(include: :posts)
  end

  def create
    user = User.new(user_params)
    if user.save
      render status: 200, json: {
                            message: 'User created.',
                            user: user
                        }.to_json
    else
      render status: 422, json: {
                            errors: user.errors
                        }.to_json
    end
  end

  def update
    if current_user.update(user_params)
      render status: 200, json: {
                            message: 'User updated.',
                            user: current_user
                        }.to_json
    else
      render status: 422, json: {
                            message: 'User could not be updated.',
                            user: current_user
                        }.to_json
    end
  end

  def destroy
    current_user.destroy

    render status: 200, json: {
                          message: 'User deleted.'
                      }.to_json
  end

  private
  def user_params
    params.require('user').permit(:email, :password, :first_name, :last_name, :username, :web_link,
                                  :photo, :role, :community_ids => [])
  end
end