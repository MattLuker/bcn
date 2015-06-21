require 'rails_helper'

describe 'User API', :type => :api do
  let!(:user) { User.create(email: 'adam@thehoick.com', password: 'beans', first_name: 'Adam', last_name: 'Sommer')}

  it 'requires login to send a list of users' do
    get '/api/users'
    expect(last_response.status).to eq(401)
  end

  it 'sends a list of users to admin role user' do
    user = User.last
    user.role = 'admin'
    user.save
    basic_authorize(user.email, 'beans')

    get '/api/users'
    expect(last_response.status).to eq(200)

    expect(json.length).to eq(1)
    expect(json[0]['email']).to eq('adam@thehoick.com')
  end

  it 'creates a user and has valid response' do
    post '/api/users', format: :json, :user => {
                               :email => 'bob@example.com',
                               :password => 'beans'
                           }
    expect(last_response.status).to eq(200)

    expect(json.length).to eq(2)
    expect(json['message']).to eq('User created.')
    expect(json['user']['email']).to eq('bob@example.com')
  end

  it 'fails to create a user with no email and has a valid response' do
    post '/api/users', format: :json, :user => {
                         :email => '',
                         :password => 'beans'
                     }

    expect(last_response.status).to eq(422)

    expect(json.length).to eq(1)
    expect(json['errors']['email']).to eq(["is invalid"])
  end

  it 'fails to create a user when there is another with the same email' do
    post '/api/users', format: :json, :user => {
                         :email => 'adam@thehoick.com',
                         :password => 'beans'
                     }

    expect(last_response.status).to eq(422)

    expect(json.length).to eq(1)
    expect(json['errors']['email']).to eq(['has already been taken'])
  end

  it 'shows user details' do
    basic_authorize(user.email, 'beans')
    get '/api/users/' + user.id.to_s

    expect(last_response.status).to eq(200)

    expect(json['first_name']).to eq('Adam')
    expect(json['email']).to eq('adam@thehoick.com')
  end

  it 'updates a user and sends a valid response' do
    basic_authorize(user.email, 'beans')

    patch '/api/users/' + user.id.to_s,
          format: :json, :user => {:first_name => 'Mike', :username => 'batman'}
    expect(last_response.status).to eq(200)

    expect(json.length).to eq(2)
    expect(json['message']).to eq('User updated.')
    expect(json['user']['first_name']).to eq('Mike')
  end

  it 'updates a user with a new profile photo' do
    extend ActionDispatch::TestProcess
    FileUtils.rm_rf(Rails.root.join('public', 'system', 'test'))
    file_count = Dir[Rails.root.join('public', 'system', '**', '*')].length

    basic_authorize(user.email, 'beans')
    puts "use.photo.name: #{user.photo.name}"

    patch '/api/users/' + user.id.to_s, :user => {
                                          :first_name => 'Mike',
                                          :photo => fixture_file_upload('files/test_avatar.jpg')
                                      }
    expect(last_response.status).to eq(200)

    new_file_count = Dir[Rails.root.join('public', 'system', '**', '*')].length

    user.reload
    expect(last_response.status).to eq(200)
    expect(user.photo).to_not eq(nil)
    expect(user.photo.name).to eq('test_avatar.jpg')

    # Not 100% sure why this is equal, but I think it has to do with the gravatar image for the default.
    # The image is uploaded though.
    expect(file_count).to eq(new_file_count)
  end

  it "deletes a user and sends a valid response" do
    basic_authorize(user.email, 'beans')

    delete '/api/users/' + user.id.to_s, format: :json

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(1)
    expect(json['message']).to eq('User deleted.')
  end

  it 'will not delete if not logged in and receive 401' do
    delete '/api/users/' + user.id.to_s, format: :json
    expect(last_response.status).to eq(401)
  end

  it 'will not delete if logged in as other user' do
    pending "Waiting..."
    expect(last_response.status).to eq(401)
  end
end