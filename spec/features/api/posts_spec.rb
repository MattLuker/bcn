require 'rails_helper'

describe 'Posts API', :type => :api do
  let!(:new_post) { Post.create(title: 'Location Post', description: 'Great job location!') }

  it 'sends a list of posts' do

    get '/api/posts'

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(1)
    expect(json[0]['title']).to eq('Location Post')
  end

  it 'shows post details' do

    get "/api/posts/#{new_post.id}"

    expect(last_response.status).to eq(200)

    expect(json['title']).to eq('Location Post')
  end

  it 'creates a post and has valid response' do
    post '/api/posts', format: :json, :post => {:title => 'JSON Post', :description => 'Great job JSON!'}

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(3)
    expect(json['message']).to eq('Post created.')
    expect(json['post']['title']).to eq('JSON Post')
  end

  it 'updates a post and has valid response' do
    patch '/api/posts/' + new_post.id.to_s, format: :json, :post => {:title => 'JSON Updated Post',
                                                                     :description => 'Great job JSON!'}

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(4)
    expect(json['message']).to eq('Post updated.')
    expect(json['post']['title']).to eq('JSON Updated Post')
  end

  it 'deletes a post and has valid response' do
    delete '/api/posts/' + new_post.id.to_s, format: :json

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(1)
    expect(json['message']).to eq('Post deleted.')
  end
end
