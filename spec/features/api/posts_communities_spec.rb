require 'rails_helper'

describe 'Post Communities API', :type => :api do
  let!(:new_post) { Post.create(title: 'Location Post', description: 'Great job location!') }
  let!(:community) { Community.create(
      name: 'Boone Community Network',
      description: "We're all part of the Boone community!",
      home_page: 'http://boonecommunitynetwork.com',
      color: '#000000'
  ) }

  it 'creates a post with a community and has valid response' do
    post '/api/posts', format: :json, :post => {:title => 'JSON Post', :description => 'Great job JSON!', :community_ids => [1]}

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(3)
    expect(json['message']).to eq('Post created.')
    expect(json['post']['title']).to eq('JSON Post')
    expect(json['post']['communities'][0]['name']).to eq('Boone Community Network')
  end

  it 'can add a post to a community' do
    patch "/api/posts/#{new_post.id}/communities/#{community.id}", format: :json, :community => {:post_ids => [1]}

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(3)
    expect(json['message']).to eq('Post added to Community.')
    expect(json['community']['posts'][0]['title']).to eq('Location Post')
  end

  it 'can add a community to a post' do
    patch "/api/communities/#{community.id}/posts/#{new_post.id}", format: :json, :post => {:community_ids => [1]}

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(4)
    expect(json['message']).to eq('Community added to Post.')
    expect(json['post']['communities'][0]['name']).to eq('Boone Community Network')
  end

  it 'can remove a community from a post' do
    post '/api/posts', format: :json, :post => {:title => 'JSON Post', :description => 'Great job JSON!', :community_ids => [1]}

    expect(last_response.status).to eq(200)

    delete '/api/communities/1/posts/2', format: :json

    expect(json.length).to eq(1)
    expect(json['message']).to eq('Community removed from Post.')

    get '/api/posts/2'
    expect(last_response.status).to eq(200)
    # Not sure why, but the request_helper isn't correctly getting the JSON from last_response.body.
    json ||= JSON.parse(last_response.body)

    expect(json['communities'].length).to eq(0)
  end

  it 'can remove a post from a community' do
    post '/api/communities', format: :json, :community => {
                               :name => 'JSON Community',
                               :description => 'Great job JSON!',
                               home_page: 'http://thehoick.com',
                               color: '#ececec',
                               post_ids: [1]
                           }
    expect(last_response.status).to eq(200)


    delete "/api/posts/#{new_post.id}/communities/#{community.id}", format: :json
    expect(last_response.status).to eq(200)

    expect(json.length).to eq(1)
    expect(json['message']).to eq('Post removed from Community.')

    get '/api/communities/2'
    expect(last_response.status).to eq(200)
    # Not sure why, but the request_helper isn't correctly getting the JSON from last_response.body.
    json ||= JSON.parse(last_response.body)

    expect(json['posts'].length).to eq(0)
  end
end