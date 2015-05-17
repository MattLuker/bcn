require 'rails_helper'

describe 'Signing In' do
  it 'signs the user in and goes to the home page' do
    User.create(email: 'adam@thehoick.com', password: 'beans', username: 'adam')
    visit new_user_session_path
    fill_in 'Email', with: 'adam@thehoick.com'
    fill_in 'Password', with: 'beans'
    click_button 'Log In'

    expect(page).to have_content('Boone')
    expect(page).to have_content('Recent Posts')
    expect(page).to have_content('Welcome adam')
  end

  it 'displays the email address in the event of a failed login' do
    visit new_user_session_path
    fill_in 'Email', with: 'adam@thehoick.com'
    fill_in 'Password', with: 'barns'
    click_button 'Log In'

    expect(page).to have_content('There was a problem logging in, please check you username and password.')
    expect(page).to have_field('Email', with: 'adam@thehoick.com')
  end
end

describe 'Signing Out' do
  it 'signs out the user goes to the home page' do
    User.create(email: 'adam@thehoick.com', password: 'beans')
    visit new_user_session_path
    fill_in 'Email', with: 'adam@thehoick.com'
    fill_in 'Password', with: 'beans'
    click_button 'Log In'

    expect(page).to have_content('Boone')
    expect(page).to have_content('Recent Posts')
    expect(page).to have_content('Welcome')

    click_link 'Log Out'
    expect(page).to have_content('You have been logged out')
    expect(page.current_path).to eq(home_path)
  end
end