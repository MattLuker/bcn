require 'rails_helper'

describe 'Signing Up with Twitter' do
  it 'allows user to sign up via Twitter', :js => true do
    visit '/'

    expect(page).to have_content('Register')
    click_link 'Register'
    click_link 'Register with Twitter'

    # When executed with other tests the browser session is reused so you don't have to log into Twitter again.
    # expect(page).to have_content('Twitter Sign up for Twitter Authorize Boone Community Networks')
    #
    # find('#username_or_email').set(TWITTER_CONFIG['username'])
    # find('#password').set(TWITTER_CONFIG['password'])
    # find('#allow').click # 'Log In' button element.

    expect(page).to have_content("Welcome #{TWITTER_CONFIG['first_name']}")
    expect(User.count).to eq(1)
  end
end