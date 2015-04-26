require 'rails_helper'

describe 'User Communities API', :type => :api do
  let!(:user) { User.create(email: 'adam@thehoick.com', password: 'beans', first_name: 'Adam', last_name: 'Sommer')}

  it 'creates a community with created_by set to the current user' do
    basic_authorize(user.email, 'beans')

    post '/api/communities', format: :json, :community => {
                               :name => 'JSON Community',
                               :description => 'Great job JSON!',
                               home_page: 'http://thehoick.com',
                               color: '#ececec',
                               created_by: user.id,
                               user_ids: [user.id]
                           }

    expect(last_response.status).to eq(200)

    expect(json['community']['created_by']).to eq(user.id)
    expect(json['community']['users'].count).to eq(1)
    expect(json['community']['users'][0]['email']).to eq(user.email)
  end

  it 'adds logged in user to a community' do
    cheese = User.create(email: 'cheese@thehoick.com', password: 'beans', first_name: 'Cheese', last_name: 'Cheeese')

    basic_authorize(cheese.email, 'beans')

    post '/api/communities', format: :json, :community => {
                               :name => 'JSON Community',
                               :description => 'Great job JSON!',
                               home_page: 'http://thehoick.com',
                               color: '#ececec',
                               created_by: cheese.id,
                           }

    expect(last_response.status).to eq(200)
    community = Community.last

    #patch "/api/users/#{user.id}/communities/#{community.id}", format: :json, :community => { user_ids: [cheese.id] }
    patch "/api/communities/#{community.id}/users", format: :json, :community => { user_ids: [cheese.id] }


    expect(last_response.status).to eq(200)
    expect(json['community']['users'].count).to eq(1)
    expect(json['community']['users'][0]['email']).to eq(cheese.email)
  end

  it 'cannot add other user to community' do
    cheese = User.create(email: 'cheese@thehoick.com', password: 'beans', first_name: 'Cheese', last_name: 'Cheeese')

    basic_authorize(user.email, 'beans')

    post '/api/communities', format: :json, :community => {
                               :name => 'JSON Community',
                               :description => 'Great job JSON!',
                               home_page: 'http://thehoick.com',
                               color: '#ececec',
                               created_by: user.id,
                           }

    expect(last_response.status).to eq(200)
    community = Community.last

    patch "/api/communities/#{community.id}/users", format: :json, :community => { user_ids: [cheese.id] }

    expect(last_response.status).to eq(401)
  end


  it 'can remove logged in user from community' do
    basic_authorize(user.email, 'beans')

    post '/api/communities', format: :json, :community => {
                               :name => 'JSON Community',
                               :description => 'Great job JSON!',
                               home_page: 'http://thehoick.com',
                               color: '#ececec',
                               created_by: user.id,
                               user_ids: [user.id]
                           }

    expect(last_response.status).to eq(200)
    community = Community.last

    delete "/api/communities/#{community.id}/users", format: :json, :community => { user_ids: [user.id] }

    expect(last_response.status).to eq(200)
    expect(community.users.count).to eq(0)
  end

  it 'cannot remove other user from community' do
    cheese = User.create(email: 'cheese@thehoick.com', password: 'beans', first_name: 'Cheese', last_name: 'Cheeese')

    basic_authorize(user.email, 'beans')
    post '/api/communities', format: :json, :community => {
                               :name => 'JSON Community',
                               :description => 'Great job JSON!',
                               home_page: 'http://thehoick.com',
                               color: '#ececec',
                               created_by: user.id,
                               user_ids: [user.id]
                           }

    expect(last_response.status).to eq(200)
    community = Community.last

    basic_authorize(cheese.email, 'beans')
    delete "/api/communities/#{community.id}/users", format: :json, :community => { user_ids: [user.id] }

    expect(last_response.status).to eq(401)
    expect(community.users.count).to eq(1)
  end
end