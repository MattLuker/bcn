require 'rails_helper'

describe 'Forgotten passwords' do

  it 'merges the user when following the email link', :js => true do
    User.create!({email: FACEBOOK_CONFIG['username'], password: 'beans'})
    user = User.last

    visit '/'

    expect(page).to have_content('Login')
    click_link 'Login'
    click_link 'Login with Facebook'

    expect(page).to have_content('Facebook Login')

    fill_in 'Email or Phone:', with: FACEBOOK_CONFIG['username']
    fill_in 'Password:', with: FACEBOOK_CONFIG['password']
    find('#u_0_2').click # 'Log In' button element.

    expect(page).to have_content("Welcome #{FACEBOOK_CONFIG['first_name']}, you have been registered using Facebook.")
    fb_user = User.last

    click_link FACEBOOK_CONFIG['first_name']
    click_link 'Edit'

    fill_in 'Email', with: FACEBOOK_CONFIG['username']
    click_button 'Update Profile'

    expect(page).to have_content('Click Here To Request Merge')
    expect {
      click_link 'Click Here To Request Merge'
    }.to change{ ActionMailer::Base.deliveries.size }.by(1)

    # Open a new tab, not 100% necessary since the checks are wrapped in the current_session block, but might come
    # in handy later.
    body = page.driver.browser.find_element(:tag_name => 'body')
    body.send_keys(:command, 't')

    Capybara.current_session do
      open_email(user.email)
      current_email.click_link 'http://'
      expect(page).to have_content('Your account has been merged, please login again.')

      click_link 'Login'
      click_link 'Login with Facebook'
      expect(page).to have_content("Welcome #{user.first_name}")
      expect(User.all.count).to eq(2)
      expect(user.facebook_id).to eq(fb_user.facebook_id)
    end
  end
end