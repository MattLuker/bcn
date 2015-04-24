require 'rails_helper'

describe 'Community API', :type => :api do
  let!(:community) { Community.create(
      name: 'Boone Community Network',
      description: "We're all part of the Boone community!",
      home_page: 'http://boonecommunitynetwork.com',
      color: '#000000'
  ) }
  let!(:user) { User.create(email: 'adam@thehoick.com', password: 'beans', first_name: 'Adam', last_name: 'Sommer')}

  it 'sends a list of communities' do

    get '/api/communities'

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(1)
    expect(json[0]['name']).to eq('Boone Community Network')
  end

  it 'shows community details' do
    get '/api/communities/' + community.id.to_s

    expect(last_response.status).to eq(200)

    expect(json['name']).to eq('Boone Community Network')
    expect(json['color']).to eq('#000000')
  end

  it 'creates a community and has valid response' do
    post '/api/communities', format: :json, :community => {
                               :name => 'JSON Community',
                               :description => 'Great job JSON!',
                               home_page: 'http://thehoick.com',
                               color: '#ececec'
                           }

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(2)
    expect(json['message']).to eq('Community created.')
    expect(json['community']['name']).to eq('JSON Community')
  end

  it 'fails to create a community with no name and has a valid response' do
    post '/api/communities', format: :json, :community => {
                               :name => '',
                               :description => 'Great job JSON!',
                               home_page: 'http://thehoick.com',
                               color: '#ececec'
                           }

    expect(last_response.status).to eq(422)

    expect(json.length).to eq(1)
    expect(json['errors']['name']).to eq(["can't be blank"])
  end

  it 'fails to create a community when there is another with the same name' do
    post '/api/communities', format: :json, :community => {
                               :name => 'Boone Community Network',
                               :description => 'Great job JSON!',
                               home_page: 'http://thehoick.com',
                               color: '#ececec'
                           }

    expect(last_response.status).to eq(422)

    expect(json.length).to eq(1)
    expect(json['errors']['name']).to eq(['has already been taken'])
  end

  it 'updates a community and sends a valid response' do
    patch '/api/communities/' + community.id.to_s,
          format: :json, :community => {:name => 'JSON Updated Community'}

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(3)
    expect(json['message']).to eq('Community updated.')
    expect(json['community']['name']).to eq('JSON Updated Community')
  end

  it "deletes a community and sends a valid response" do
    basic_authorize(user.email, 'beans')

    delete '/api/communities/' + community.id.to_s, format: :json

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(1)
    expect(json['message']).to eq('Community deleted.')
  end

end