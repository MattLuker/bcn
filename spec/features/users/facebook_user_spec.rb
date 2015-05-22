require 'rails_helper'

describe 'Signing Up with Facebook' do
  before do
    Community.create({name: 'BCN Rails',
                      description: 'BCN Rails Open Source project.',
                      home_page: 'https://github.com/asommer70/bcn',
                      color: '#333333'
                     })
  end

  it 'allows user to sign up via Facebook', :js => true do
    visit '/'

    expect(page).to have_content('Register')
    click_link 'Register'
    click_link 'Register with Facebook'

    expect(page).to have_content('Facebook Login')

    fill_in 'Email or Phone:', with: FACEBOOK_CONFIG['username']
    fill_in 'Password:', with: FACEBOOK_CONFIG['password']
    #sleep(10)
    find('#u_0_2').click # 'Log In' button element.

    expect(User.count).to eq(1)
    expect(page).to have_content("Welcome #{FACEBOOK_CONFIG['first_name']}, you have been registered using Facebook.")
  end

  it 'creates Events for Facebook user', :js => true do
    expect(User.count).to eq(0)

    visit '/'

    expect(page).to have_content('Register')
    click_link 'Login'
    click_link 'Login with Facebook'

    click_link 'Communities'
    click_link 'BCN Rails'
    click_button 'Join Community'

    click_link 'Log Out'
    click_link 'Login'
    click_link 'Login with Facebook'

    expect(page).to have_content('More Facebook Integration')
  end
end