require 'rails_helper'

describe 'Searches API', :type => :api do
  let!(:post1) { Post.create(title: 'Location Event', description: 'Great job location!') }
  let!(:post2) { Post.create(title: '2nd Event', description: 'Great job beans!') }
  let!(:post3) { Post.create(title: '3 Thing', description: 'Doing things tdd...') }

  let!(:comment1) { Comment.create(content: 'Comment on 1st.', post: post1)}
  let!(:comment2) { Comment.create(content: 'Comment on 1st comment...', parent_id: comment1.id)}


  it 'returns one post' do
    get '/api/searches?query=location', format: :json

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(2)
    expect(json['results'][0]['title']).to eq('Location Event')
  end

  it 'returns two posts' do
    get '/api/searches?query=Event', format: :json

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(2)
    expect(json['message']).to eq('Found 2 matches.')
    expect(json['results'][0]['title']).to eq('Location Event')
    expect(json['results'][1]['title']).to eq('2nd Event')
  end

  it 'returns comments' do
    get '/api/searches?query=Comment', format: :json

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(2)
    expect(json['results'][1]['content']).to eq('Comment on 1st.')
    expect(json['results'][0]['content']).to eq('Comment on 1st comment...')
  end

  it 'returns 0 count if no matches' do
    get '/api/searches?query=balls', format: :json

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(2)
    expect(json['message']).to eq('Found 0 matches.')
    expect(json['results']).to eq([])
  end
end