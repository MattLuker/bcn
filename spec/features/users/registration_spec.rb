require 'rails_helper'

describe 'Signing Up' do
  it 'allows user to sign up via email' do
    expect(User.count).to eq(0)

    visit '/'

    expect(page).to have_content('Register')
    click_link 'Register'

    fill_in 'Email', with: 'adam@thehoick.com'
    fill_in 'Password', with: 'beans'
    click_button 'Register'

    expect(User.count).to eq(1)
  end

  it 'uses gravatar for profile photo if available' do
    visit '/'

    expect(page).to have_content('Register')
    click_link 'Register'

    fill_in 'Email', with: GOOGLE_CONFIG['username']
    fill_in 'Password', with: 'beans'
    click_button 'Register'

    user = User.find_by(email: GOOGLE_CONFIG['username'])
    hash = Digest::MD5.hexdigest(GOOGLE_CONFIG['username'])

    #sleep(1)
    expect(page).to have_content('Welcome you have successfully registered.')
    expect(user.photo.name).to eq(hash)
  end

  it 'sends welcome email to new user' do
    expect(User.count).to eq(0)

    visit '/'

    expect(page).to have_content('Register')
    click_link 'Register'

    fill_in 'Email', with: 'adam@thehoick.com'
    fill_in 'Password', with: 'beans'

    expect {
       click_button 'Register'
       expect(User.count).to eq(1)
    }.to change{ ActionMailer::Base.deliveries.size }.by(1)

    user = User.last
    open_email(user.email)
    expect(current_email.body).to have_content('http://localhost:3000/users/' + user.id.to_s)
  end
end