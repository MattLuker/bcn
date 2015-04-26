require 'rails_helper'

describe '"Updating communities" 'do
  let(:user) { create(:user) }

  it 'is successful with valid content' do
    sign_in user, password: 'beans'
    create_community

    expect(page).to have_content('Boone Community Network')
    expect(page).to have_content('Community was successfully created.')

    click_link 'Edit'

    fill_in 'Color', with: '#ffffff'
    click_button 'Save Community'
    expect(page).to have_content('Community was successfully updated.')
  end

  it 'has a log entry after creation' do
    sign_in user, password: 'beans'
    create_community

    click_link 'Edit'
    fill_in 'Color', with: '#ffffff'
    click_button 'Save Community'

    log = Log.last

    expect(log.community).to eq(Community.last)
    expect(log.action).to eq('updated')
  end

  it 'will not allow updating Community if user is not the creator' do
    sign_in user, password: 'beans'
    create_community
    community = Community.last
    click_link 'Log Out'

    User.create(email: 'cheese@thehoick.com', password: 'beans')
    visit new_user_session_path
    fill_in 'Email', with: 'cheese@thehoick.com'
    fill_in 'Password', with: 'beans'
    click_button 'Log In'

    visit '/communities/' + community.id.to_s
    click_link 'Edit'

    expect(page).to have_content('Must be the creator of the Community to update it.')
  end
end