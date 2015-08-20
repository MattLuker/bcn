require 'rails_helper'

describe 'Community Subscribers API', :type => :api do
  let!(:user) { User.create(email: 'adam@thehoick.com',
                            password: 'beans',
                            first_name: 'Adam',
                            last_name: 'Sommer',
                            notify_instant: true
  )}
  let!(:user2) { User.create(email: 'bob@thehoick.com', password: 'beans', first_name: 'Bob', last_name: 'Slidell')}
  let!(:new_post) { Post.create(title: 'Location Post', description: 'Great job location!') }
  let!(:community) { Community.create(
      name: 'Boone Community Network',
      description: "We're all part of the Boone community!",
      home_page: 'http://boonecommunitynetwork.com',
      color: '#000000',
      created_by: user.id
  ) }

  it 'subscribes user to community' do
    basic_authorize(user.email, 'beans')

    post "/api/communities/#{community.id}/subscribers", format: :json, :user_id => user.id

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(4)
    expect(json['message']).to eq('User subscribed.')
    expect(json['community']['id']).to eq(community.id)
    expect(community.subscribers.count).to eq(1)
  end

  it 'unsubscribes user from community' do
    basic_authorize(user.email, 'beans')

    post "/api/communities/#{community.id}/subscribers", format: :json, :user_id => user.id

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(4)
    expect(json['message']).to eq('User subscribed.')
    expect(json['community']['id']).to eq(community.id)
    expect(community.subscribers.count).to eq(1)

    delete "/api/communities/#{community.id}/subscribers/#{user.id}", format: :json
    del_json = JSON.parse(last_response.body)

    expect(del_json.length).to eq(4)
    expect(del_json['message']).to eq('User unsubscribed.')
    expect(del_json['community']['id']).to eq(community.id)
    expect(community.subscribers.count).to eq(0)
  end

  it 'sends an email to subscribers when a new post is created' do
    basic_authorize(user.email, 'beans')

    post "/api/communities/#{community.id}/subscribers", format: :json, :user_id => user.id

    expect(last_response.status).to eq(200)
    expect(community.subscribers.count).to eq(1)

    basic_authorize(user2.email, 'beans')

    expect {
      post '/api/posts', format: :json, :post => {
                           :title => 'JSON Post',
                           :description => 'Great job JSON!',
                           :community_ids => [community.id]
                       }
    }.to change{ ActionMailer::Base.deliveries.size }.by(1)
  end
end