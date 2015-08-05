require 'rails_helper'

describe 'Badges API', :type => :api do
  let!(:new_post) { Post.create(title: 'Location Post', description: 'Great job location!') }
  let!(:user) { User.create(email: 'adam@thehoick.com', password: 'beans', username: 'adam')}
  let!(:badge) { Badge.create(name: 'Comment Beginner', description: 'Has Commented', rules: 'user.comments.count > 0')}
  let(:comment) { Comment.create(content: 'Fun Comment #1', post_id: new_post.id, user_id: user.id) }

  it 'sends a list of badges' do
    get '/api/badges'
    expect(last_response.status).to eq(401)
  end

  it 'sends details of a badge if logged in' do
    basic_authorize(user.email, 'beans')

    post "/api/posts/#{new_post.id}/comments", format: :json, :comment => {:content => 'Good content for a comment.' }

    get '/api/badges/' + badge.id.to_s
    expect(last_response.status).to eq(200)

    expect(json.length).to eq(8)
    expect(json['name']).to eq('Comment Beginner')
    expect(json['users'][0]['username']).to eq('adam')
  end
end
