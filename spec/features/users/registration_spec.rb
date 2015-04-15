require 'rails_helper'

describe 'Signing Up' do
  it 'allows user to sign up via email' do
    expect(User.count).to eq(0)

    visit '/'

    expect(page).to have_content('Sign Up')
    click_link 'Sign Up'

    fill_in 'Email', with: 'adam@thehoick.com'
    fill_in 'Password', with: 'beans'
    click_button 'Sign Up'

    expect(User.count).to eq(1)
  end
end