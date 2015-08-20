require 'rails_helper'

describe 'Community API', :type => :api do
  let!(:user) { User.create(email: 'adam@thehoick.com', password: 'beans', first_name: 'Adam', last_name: 'Sommer')}
  let!(:community) { Community.create(
      name: 'Boone Community Network',
      description: "We're all part of the Boone community!",
      home_page: 'http://boonecommunitynetwork.com',
      color: '#000000',
      created_by: user.id
  ) }

  it 'sends a list of communities' do

    get '/api/communities'

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(1)
    expect(json[0]['name']).to eq('Boone Community Network')
  end

  it 'shows community details' do
    get '/api/communities/' + community.slug

    expect(last_response.status).to eq(200)

    expect(json['community']['name']).to eq('Boone Community Network')
    expect(json['community']['color']).to eq('#000000')
  end

  it 'creates a community and has valid response' do
    basic_authorize(user.email, 'beans')

    post '/api/communities', format: :json, :community => {
                               :name => 'JSON Community',
                               :description => 'Great job JSON!',
                               home_page: 'http://thehoick.com',
                               color: '#ececec'
                           }

    expect(last_response.status).to eq(200)
    community = Community.last

    expect(json.length).to eq(2)
    expect(json['message']).to eq('Community created.')
    expect(json['community']['name']).to eq('JSON Community')
    expect(json['community']['created_by']).to eq(user.id)
  end

  it 'fails to create a community with no name and has a valid response' do
    basic_authorize(user.email, 'beans')

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
    basic_authorize(user.email, 'beans')

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
    basic_authorize(user.email, 'beans')

    patch '/api/communities/' + community.id.to_s,
          format: :json, :community => {:name => 'JSON Updated Community'}

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(3)
    expect(json['message']).to eq('Community updated.')
    expect(json['community']['name']).to eq('JSON Updated Community')
  end

  it 'fails to update when logged in as non-creator user' do
    cheese = User.create(email: 'cheese@thehoick.com', password: 'beans', first_name: 'Cheese', last_name: 'Cheeese')
    basic_authorize(cheese.email, 'beans')

    patch '/api/communities/' + community.id.to_s,
          format: :json, :community => {:name => 'JSON Updated Community'}

    expect(last_response.status).to eq(401)

    expect(json.length).to eq(2)
    expect(json['message']).to eq('Only the community creator and update the community.')
  end

  it "deletes a community and sends a valid response" do
    basic_authorize(user.email, 'beans')

    delete '/api/communities/' + community.id.to_s, format: :json

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(1)
    expect(json['message']).to eq('Community deleted.')
  end

  it 'updates social links' do
    basic_authorize(user.email, 'beans')

    facebook = 'https://www.facebook.com/pages/Boone-Community-Network/334012336716987?fref=ts'
    twitter = 'https://twitter.com/asommer'
    google = 'https://plus.google.com/108906335613240420220/about'

    patch '/api/communities/' + community.id.to_s,
          format: :json, :community => {:facebook_link => facebook,
                                        :twitter_link => twitter,
                                        :google_link => google
        }

    expect(last_response.status).to eq(200)

    expect(json.length).to eq(3)
    expect(json['message']).to eq('Community updated.')
    expect(json['community']['facebook_link']).to eq(facebook)
    expect(json['community']['twitter_link']).to eq(twitter)
    expect(json['community']['google_link']).to eq(google)
  end

  it 'creates a community with an image' do
    extend ActionDispatch::TestProcess
    FileUtils.rm_rf(Rails.root.join('public', 'system', 'test'))
    file_count = Dir[Rails.root.join('public', 'system', '**', '*')].length

    basic_authorize(user.email, 'beans')

    post '/api/communities', :community => {
                               name: 'JSON Community',
                               description: 'Great job JSON!',
                               home_page: 'http://thehoick.com',
                               color: '#ececec',
                               :image =>  fixture_file_upload('files/test_avatar.jpg')
                           }
    new_file_count = Dir[Rails.root.join('public', 'system', '**', '*')].length
    community = Community.last

    expect(last_response.status).to eq(200)
    expect(community.image).to_not eq(nil)
    expect(community.image.name).to eq('test_avatar.jpg')
    expect(file_count).to be < new_file_count
  end
end