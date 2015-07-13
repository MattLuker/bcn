require 'rails_helper'

describe 'Forgotten passwords' do

  it 'merges the Facebook user when following the email link', :js => true, :visual => true, :firefox => true do
    User.create!({email: FACEBOOK_CONFIG['username'], password: 'beans'})
    user = User.last

    visit '/'

    expect(page).to have_content('Login')
    click_link 'Login'
    click_link 'Login with Facebook'

    #
    # Uncomment if running the test stand alone because you don't need to login to Facebook again if run after the
    # other Facebook tests.
    #
    expect(page).to have_content('Facebook Login')

    fill_in 'Email or Phone:', with: FACEBOOK_CONFIG['username']
    fill_in 'Password:', with: FACEBOOK_CONFIG['password']
    find('#u_0_2').click # 'Log In' button element.

    expect(page).to have_content("Welcome #{FACEBOOK_CONFIG['first_name']}, you have been registered using Facebook.")
    fb_user = User.last

    find('.profile').click
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
      sleep(1)

      expect(page).to have_content("Welcome #{user.first_name}")
      expect(User.all.count).to eq(2)
      expect(user.facebook_id).to eq(fb_user.facebook_id)
      page.driver.finish!
    end
  end

  it 'merges the Twitter user when following the email link', :js => true, :visual => true, :firefox => true do
    User.create!({email: TWITTER_CONFIG['username'] + '@thehoick.com', password: 'beans'})
    user = User.last

    visit '/'

    expect(page).to have_content('Login')
    click_link 'Login'
    click_link 'Login with Twitter'

    expect(page).to have_content('Twitter Sign up for Twitter Authorize Boone Community Networks')

    find('#username_or_email').set(TWITTER_CONFIG['username'])
    find('#password').set(TWITTER_CONFIG['password'])
    find('#allow').click # 'Log In' button element.
    expect(page).to have_content("Welcome #{TWITTER_CONFIG['first_name']}")

    tw_user = User.last

    find('.profile').click
    click_link 'Edit'

    fill_in 'Email', with: TWITTER_CONFIG['username'] + '@thehoick.com'
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
      click_link 'Login with Twitter'
      sleep(1)

      expect(page).to have_content("Welcome #{user.first_name}")
      expect(User.all.count).to eq(2)
      expect(user.facebook_id).to eq(tw_user.twitter_id)
      page.driver.finish!
    end
  end

end