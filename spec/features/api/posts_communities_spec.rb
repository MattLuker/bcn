require 'rails_helper'

describe 'Post Communities API', :type => :api do
  let!(:new_post) { Post.create(title: 'Location Post 1', description: 'Great job location!') }
  # let!(:community) { Community.create(
  #     name: 'Boone Community Network 1',
  #     description: "We're all part of the Boone community!",
  #     home_page: 'http://boonecommunitynetwork.com',
  #     color: '#000000'
  # ) }

  it 'creates a post with a community and has valid response' do
    create_api_community
    community = Community.find(json['community']['id'])

    post '/api/posts', format: :json, :post => {:title => 'JSON Post 2', :description => 'Great job JSON!',
                                                :community_ids => [community.id]}

    expect(last_response.status).to eq(200)

    json ||= JSON.parse(last_response.body)

    expect(json.length).to eq(3)
    expect(json['message']).to eq('Post created.')
    expect(json['post']['title']).to eq('JSON Post 2')
    expect(json['post']['communities'][0]['name']).to eq('Boone Community Network')
  end

  it 'can add a post to a community' do
    create_api_community
    community = Community.find(json['community']['id'])

    patch "/api/posts/#{new_post.id}/communities/#{community.id}", format: :json,
          :community => {:post_ids => [community.id]}

    expect(last_response.status).to eq(200)
    json ||= JSON.parse(last_response.body)

    expect(json.length).to eq(3)
    expect(json['message']).to eq('Post added to Community.')
    expect(json['community']['posts'][0]['title']).to eq('Location Post 1')
  end

  it 'can add a community to a post' do
    create_api_community
    community = Community.find(json['community']['id'])

    patch "/api/communities/#{community.id}/posts/#{new_post.id}", format: :json,
          :post => {:community_ids => [community.id]}

    expect(last_response.status).to eq(200)
    json ||= JSON.parse(last_response.body)

    expect(json.length).to eq(4)
    expect(json['message']).to eq('Community added to Post.')
    expect(json['post']['communities'][0]['name']).to eq('Boone Community Network')
  end

  it 'can remove a community from a post' do
    create_api_community
    community = Community.find(json['community']['id'])

    post '/api/posts', format: :json, :post => {:title => 'JSON Post', :description => 'Great job JSON!',
                                                :community_ids => [community.id]}

    expect(last_response.status).to eq(200)
    json ||= JSON.parse(last_response.body)
    this_post = Post.find(json['post']['id'])

    delete "/api/communities/#{community.id}/posts/#{this_post.id}", format: :json
    del_json ||= JSON.parse(last_response.body)

    expect(del_json.length).to eq(1)
    expect(del_json['message']).to eq('Community removed from Post.')

    get '/api/posts/' + this_post.id.to_s
    expect(last_response.status).to eq(200)
    # Not sure why, but the request_helper isn't correctly getting the JSON from last_response.body.
    get_json ||= JSON.parse(last_response.body)

    expect(get_json['communities'].length).to eq(0)
  end

  it 'can remove a post from a community' do
    create_api_community
    community = Community.find(json['community']['id'])

    post '/api/communities', format: :json, :community => {
                               :name => 'JSON Community',
                               :description => 'Great job JSON!',
                               home_page: 'http://thehoick.com',
                               color: '#ececec',
                               post_ids: [1]
                           }
    expect(last_response.status).to eq(200)
    json ||= JSON.parse(last_response.body)

    delete "/api/posts/#{new_post.id}/communities/#{community.id}", format: :json
    expect(last_response.status).to eq(200)
    del_json ||= JSON.parse(last_response.body)

    expect(del_json.length).to eq(1)
    expect(del_json['message']).to eq('Post removed from Community.')

    get '/api/communities/' + community.id.to_s
    expect(last_response.status).to eq(200)
    # Not sure why, but the request_helper isn't correctly getting the JSON from last_response.body.
    get_json ||= JSON.parse(last_response.body)

    expect(get_json['posts'].length).to eq(0)
  end
end