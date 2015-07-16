require 'rails_helper'

describe '"Updating organizations" 'do
  let(:user) { create(:user) }

  it 'is successful with valid content', :js => true do
    sign_in user, password: 'beans'
    create_organization

    expect(page).to have_content('BCN')
    expect(page).to have_content('Organization created.')

    find('.edit-organization').click

    fill_in 'Color', with: '#ffffff'
    click_button 'Save Organization'
    expect(page).to have_content('Organization updated.')
  end

  it 'will not allow updating Community if user is not the creator', :js => true do
    sign_in user, password: 'beans'
    create_organization
    organization = Organization.last
    click_link 'Log Out'

    User.create(email: 'cheese@thehoick.com', password: 'beans')
    visit new_user_session_path
    fill_in 'Email', with: 'cheese@thehoick.com'
    fill_in 'Password', with: 'beans'
    click_button 'Log In'

    visit '/organizations/' + organization.slug
    expect(page).to_not have_css('.edit-organization')
  end
end