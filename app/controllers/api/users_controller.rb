class Api::UsersController < Api::ApiController
  def index
    users = User.all
    render json: users.as_json
  end

  def show
    user = User.find(params[:id])
    render json: user.as_json(include: :posts)
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
    user = User.find(params[:id])

    if user.update(user_params)
      render status: 200, json: {
                            message: 'User updated.',
                            user: user
                        }.to_json
    else
      render status: 422, json: {
                            message: 'User could not be updated.',
                            user: user
                        }.to_json
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy

    render status: 200, json: {
                          message: 'User deleted.'
                      }.to_json
  end

  private
  def user_params
    params.require('user').permit('email', 'password', 'first_name', 'last_name')
  end
end