require 'rails_helper'

describe 'Comments API', :type => :api do
  let!(:new_post) { Post.create(title: 'Location Post', description: 'Great job location!') }
  let!(:user) { User.create(email: 'adam@thehoick.com', password: 'beans', first_name: 'Adam', last_name: 'Sommer')}
  let(:comment) { Comment.create(content: 'Fun Comment #1', post_id: new_post.id) }

  it 'sends a comment' do
    get '/api/comments/' + comment.id.to_s

    expect(last_response.status).to eq(200)
    expect(json['content']).to eq('Fun Comment #1')
  end

  it 'creates a comment on a post' do
    basic_authorize(user.email, 'beans')

    post "/api/posts/#{new_post.id}/comments", format: :json, :comment => {:content => 'Good content for a comment.' }

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(2)
    expect(json['comment']['content']).to eq('Good content for a comment.')
  end

  it 'creates a comment on a comment' do
    basic_authorize(user.email, 'beans')

    post "/api/posts/#{new_post.id}/comments", format: :json, :comment => {:content => 'Good content for a comment.' }

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(2)
    expect(json['comment']['content']).to eq('Good content for a comment.')
    comment = Comment.last

    post "/api/comments/#{comment.id}/comments", format: :json, :comment => { :content => 'Great comment on the Post' }
    c_json = JSON.parse(last_response.body)
    c_comment = Comment.last

    expect(last_response.status).to eq(200)
    expect(c_json.length).to eq(2)
    expect(c_json['comment']['content']).to eq('Great comment on the Post')
    expect(c_comment.parent).to eq(comment)
  end

  it 'updates a comment' do
    basic_authorize(user.email, 'beans')

    post "/api/posts/#{new_post.id}/comments", format: :json, :comment => {
                                                 :content => 'Good content for a comment.',
                                             }
    expect(last_response.status).to eq(200)

    expect(json.length).to eq(2)
    expect(json['message']).to eq('Comment created.')
    expect(json['comment']['content']).to eq('Good content for a comment.')
    comment = Comment.last

    patch "/api/comments/#{comment.id}", format: :json, :comment => {
                                           :content => 'Updated content for a comment.',
                                       }

    expect(last_response.status).to eq(200)
    new_json = JSON.parse(last_response.body)

    expect(new_json.length).to eq(2)
    expect(new_json['message']).to eq('Comment updated.')
    expect(new_json['comment']['content']).to eq('Updated content for a comment.')
  end

  it 'destroys a comment' do
    basic_authorize(user.email, 'beans')

    post "/api/posts/#{new_post.id}/comments", format: :json, :comment => {
                                                 :content => 'Good content for a comment.',
                                             }
    expect(last_response.status).to eq(200)

    expect(json.length).to eq(2)
    expect(json['message']).to eq('Comment created.')
    expect(json['comment']['content']).to eq('Good content for a comment.')
    comment = Comment.last

    delete "/api/comments/#{comment.id}", format: :json

    expect(last_response.status).to eq(200)
    new_json = JSON.parse(last_response.body)

    expect(new_json.length).to eq(1)
    expect(new_json['message']).to eq('Comment deleted.')
  end

  let!(:user2) { User.create(email: 'bob@thehoick.com', password: 'beans', first_name: 'Bob', last_name: 'Slidell')}

  it 'creates a comment with an image' do
    extend ActionDispatch::TestProcess
    basic_authorize(user2.email, 'beans')

    post "/api/posts/#{new_post.id}/subscribers", format: :json, :user_id => user2.id
    expect(last_response.status).to eq(200)
    expect(new_post.subscribers.count).to eq(1)

    # Log in as user (first user) and make a comment which should email user2.
    basic_authorize(user.email, 'beans')
    expect {
      post "/api/posts/#{new_post.id}/comments", format: :json, :comment => {
                                                   :content => 'Good content for a comment.',
                                               }
    }.to change{ ActionMailer::Base.deliveries.size }.by(1)
  end
end