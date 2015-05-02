require 'rails_helper'

describe 'Posts API', :type => :api do
  let!(:new_post) { Post.create(title: 'Location Post', description: 'Great job location!') }
  let!(:user) { User.create(email: 'adam@thehoick.com', password: 'beans', first_name: 'Adam', last_name: 'Sommer')}


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

  it 'creates a post with a user and has valid response' do
    basic_authorize(user.email, 'beans')

    post '/api/posts', format: :json, :post => {:title => 'JSON Post',
                                                :description => 'Great job JSON!'}

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(3)
    expect(json['message']).to eq('Post created.')
    expect(json['post']['title']).to eq('JSON Post')
    expect(json['post']['user']['email']).to eq(user.email)
  end

  it 'updates a post and has valid response' do
    basic_authorize(user.email, 'beans')
    post2 = Post.create(title: 'Location Post', description: 'Great job location!', user: user)

    patch '/api/posts/' + post2.id.to_s, format: :json, :post => {:title => 'JSON Updated Post',
                                                                     :description => 'Great job JSON!'}

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(4)
    expect(json['message']).to eq('Post updated.')
    expect(json['post']['title']).to eq('JSON Updated Post')
  end

  it 'deletes a post and has valid response' do
    basic_authorize(user.email, 'beans')
    post2 = Post.create(title: 'Location Post', description: 'Great job location!', user: user)

    delete '/api/posts/' + post2.id.to_s, format: :json

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(1)
    expect(json['message']).to eq('Post deleted.')
  end

  it 'will not update post if not logged in as non-post user' do
    post2 = Post.create(title: 'Location Post', description: 'Great job location!', user: user)

    user2 = User.create(email: 'cheese@thehoick.com', password: 'beans')
    basic_authorize(user2.email, 'beans')

    patch '/api/posts/' + post2.id.to_s, format: :json, :post => {:title => 'JSON Updated Post',
                                                                  :description => 'Great job JSON!'}

    expect(last_response.status).to eq(404)
  end

  it 'creates a post with one location' do
    basic_authorize(user.email, 'beans')
    post '/api/posts', format: :json, :post => {:title => 'JSON Post',
                                                :description => 'Great job JSON!',
                                                :user_id => user.id,
                                                :lat => 36.2168215386211,
                                                :lon => -81.682448387146}
    expect(last_response.status).to eq(200)

    expect(json.length).to eq(3)
    expect(json['message']).to eq('Post created.')
    expect(json['post']['title']).to eq('JSON Post')
    expect(json['post']['locations'][0]['name']).to eq('Kenneth E. Peacock Hall')
  end

  it 'creates a post with multiple locations' do
    basic_authorize(user.email, 'beans')
    post '/api/posts', format: :json, :post => {:title => 'JSON Post',
                                                :description => 'Great job JSON!',
                                                :user_id => user.id,
                                                :lat => 36.2168215386211,
                                                :lon => -81.682448387146}
    expect(last_response.status).to eq(200)
    post = Post.last

    expect(json.length).to eq(3)
    expect(json['message']).to eq('Post created.')
    expect(json['post']['title']).to eq('JSON Post')
    expect(json['post']['locations'][0]['name']).to eq('Kenneth E. Peacock Hall')

    post "/api/posts/#{post.id}/locations", format: :json, :location => {lat: 36.2116343280817, lon: -81.685516834259}
    expect(last_response.status).to eq(200)
    loc_json ||= JSON.parse(last_response.body)

    expect(loc_json['post']['locations'][0]['name']).to eq('Kidd Brewer Stadium')
    expect(loc_json['post']['locations'][1]['name']).to eq('Kenneth E. Peacock Hall')
  end

  it 'creates a post with an event' do
    start_date = DateTime.strptime('5/25/2015 05:05:05', '%m/%d/%Y %I:%M:%S')
    end_date = DateTime.strptime('5/25/2015 06:05:05', '%m/%d/%Y %I:%M:%S')

    basic_authorize(user.email, 'beans')
    post '/api/posts', format: :json, :post => {:title => 'JSON Post',
                                                :description => 'Great job JSON!',
                                                :user_id => user.id,
                                                :lat => 36.2168215386211,
                                                :lon => -81.682448387146,
                                                :start_date => '5/25/2015',
                                                :start_time =>  '05:05:05',
                                                :end_date => '5/25/2015 06:05:05',
                                                :end_time =>  '06:05:05',
                                               }
    expect(last_response.status).to eq(200)

    expect(json.length).to eq(3)
    expect(json['message']).to eq('Post created.')
    expect(json['post']['locations'][0]['name']).to eq('Kenneth E. Peacock Hall')
    post = Post.last

    expect(post.start_date).to eq(Date.strptime('05/25/2015', '%m/%d/%Y'))
    expect(post.end_date).to eq(Date.strptime('05/25/2015', '%m/%d/%Y'))
    expect((post.start_time - 4.hours).to_s(:time)).to eq('05:05')
    expect((post.end_time - 4.hours).to_s(:time)).to eq('06:05')
  end
end
