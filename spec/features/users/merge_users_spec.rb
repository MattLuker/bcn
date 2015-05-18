require 'rails_helper'

describe 'Forgotten passwords' do

  it 'sends a user an email', :js => true do
    User.create!({email: FACEBOOK_CONFIG['username'], password: 'beans'})

    visit '/'

    expect(page).to have_content('Login')
    click_link 'Login'
    click_link 'Login with Facebook'

    expect(page).to have_content('Facebook Login')

    fill_in 'Email or Phone:', with: FACEBOOK_CONFIG['username']
    fill_in 'Password:', with: FACEBOOK_CONFIG['password']
    find('#u_0_2').click # 'Log In' button element.

    expect(page).to have_content("Welcome #{FACEBOOK_CONFIG['first_name']}, you have been registered using Facebook.")

    click_link FACEBOOK_CONFIG['first_name']
    click_link 'Edit'

    fill_in 'Email', with: FACEBOOK_CONFIG['username']
    click_button 'Update Profile'

    expect(page).to have_content('Click Here To Request Merge')
    sleep(3)

    expect {
      click_link 'Click Here To Request Merge'
    }.to change{ ActionMailer::Base.deliveries.size }.by(1)
  end
end