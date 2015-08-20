require 'rails_helper'

describe '"Updating communities" 'do
  let(:user) { create(:user, role: 'admin') }

  before do
    Role.create(user: user, name: 'admin')
  end

  it 'is successful with valid content', :js => true do
    sign_in user, password: 'beans'
    create_community

    expect(page).to have_content('Boone Community Network')
    expect(page).to have_content('Community was successfully created.')

    find('.edit-community').click

    fill_in 'Color', with: '#ffffff'
    click_button 'Save Community'
    expect(page).to have_content('Community was successfully updated.')
  end

  it 'will not allow updating Community if user is not the creator', :js => true do
    sign_in user, password: 'beans'
    create_community
    community = Community.last
    click_link 'Log Out'

    User.create(email: 'cheese@thehoick.com', password: 'beans')
    visit new_user_session_path
    fill_in 'Email', with: 'cheese@thehoick.com'
    fill_in 'Password', with: 'beans'
    click_button 'Log In'

    visit '/communities/' + community.slug
    expect(page).to_not have_css('.edit-community')
  end
end