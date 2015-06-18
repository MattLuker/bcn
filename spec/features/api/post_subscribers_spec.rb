require 'rails_helper'

describe 'Post Subscribers API', :type => :api do
  let!(:new_post) { Post.create(title: 'Location Post', description: 'Great job location!') }
  let!(:user) { User.create(email: 'adam@thehoick.com', password: 'beans', first_name: 'Adam', last_name: 'Sommer')}

  it 'subscribes user to post' do
    basic_authorize(user.email, 'beans')

    post "/api/posts/#{new_post.id}/subscribers", format: :json, :user_id => user.id

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(4)
    expect(json['message']).to eq('User subscribed.')
    expect(json['post']['id']).to eq(new_post.id)
    expect(new_post.subscribers.count).to eq(1)
  end

  it 'unsubscribes user from post' do
    basic_authorize(user.email, 'beans')

    post "/api/posts/#{new_post.id}/subscribers", format: :json, :user_id => user.id

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(4)
    expect(json['message']).to eq('User subscribed.')
    expect(json['post']['id']).to eq(new_post.id)
    expect(new_post.subscribers.count).to eq(1)

    delete "/api/posts/#{new_post.id}/subscribers/#{user.id}", format: :json
    del_json = JSON.parse(last_response.body)

    expect(del_json.length).to eq(4)
    expect(del_json['message']).to eq('User unsubscribed.')
    expect(del_json['post']['id']).to eq(new_post.id)
    expect(new_post.subscribers.count).to eq(0)
  end
end