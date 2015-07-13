require 'rails_helper'

describe 'Signing Up with Google' do
  it 'allows user to sign up via Google', :js => true, :visual => true, :firefox => true do
    visit '/'

    expect(page).to have_content('Register')
    click_link 'Register'
    click_link 'Register with Google'

    expect(page).to have_content('Sign in with your Google Account')

    #find('#username_or_email').set(TWITTER_CONFIG['username'])
    #find('#password').set(TWITTER_CONFIG['password'])
    #find('#allow').click # 'Log In' button element.
    fill_in 'Email', with: GOOGLE_CONFIG['username']
    click_button 'Next'
    fill_in 'Password', with: GOOGLE_CONFIG['password']
    click_button 'Sign in'

    click_button 'Accept'

    expect(page).to have_content("Welcome #{GOOGLE_CONFIG['first_name']}")
    expect(User.count).to eq(1)
  end
end