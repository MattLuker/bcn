require 'rails_helper'

describe 'Location API', :type => :api do
  #Watauga County Public Library, 140, Queen Street, Boone,
  # Watauga County, North Carolina, 28607,
  # United States of America (library)
  # 36.22005255, -81.6826246249324
  let(:user) { create(:user) }

  let!(:location) { Location.create(
      lat: 36.21991,
      lon: -81.68261,
      name: 'Watauga County Public Library',
      address: '140 Queen Street',
      city: 'Boone',
      state: 'North Carolina',
      postcode: '28607',
      county: 'Watauga',
      country: 'us',
  ) }

  it 'creates a location and has valid response' do
    basic_authorize(user.email, 'beans')

    post '/api/locations', format: :json, :location => {lat: 36.2168215386211, lon: -81.682448387146}

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(3)
    expect(json['message']).to eq('Location created.')
    expect(json['locations'][0]['lat']).to eq(36.2168215386211)
    expect(json['locations'][0]['name']).to eq('Kenneth E. Peacock Hall')
  end

  it 'updates a location and has valid response' do
    basic_authorize(user.email, 'beans')
    patch '/api/locations/' + location.id.to_s, format: :json, :location => {lat: 36.2168215386211,
                                                                             lon: -81.682448387146}

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(4)
    expect(json['message']).to eq('Location updated.')
    expect(json['location']['name']).to eq('Kenneth E. Peacock Hall')
  end

  it 'deletes a location from a post and has valid response' do
    basic_authorize(user.email, 'beans')
    post = Post.create(title: 'Location Post',
                       description: 'Great job location!',
                       user: user,
                       locations: [location])

    delete "/api/locations/#{location.id}", format: :json, post_id: post.id

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(1)
    expect(json['message']).to eq('Location deleted.')
  end

  before do
    for i in 1..3
      Location.create(
          lat: 36.21991,
          lon: -81.68261,
          name: 'Watauga County Public Library',
          address: '140 Queen Street',
          city: 'Boone',
          state: 'North Carolina',
          postcode: '28607',
          county: 'Watauga',
          country: 'us'
      )
      location = Location.last

      Post.create(title: "Location API Post #{i}", description: "Number #{i} post.", locations: [location])
    end
  end

  it 'gets a list of posts with the location name' do

    get "/api/locations/1?lat=36.21991&lon=-81.68261", format: :json

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(3)
    expect(json['message']).to eq('Location found.')
    expect(json['location']['name']).to eq('Watauga County Public Library')
    expect(json['posts'].count).to eq(3)
  end
end
