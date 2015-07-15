require 'rails_helper'

describe "Delete organizations" do
  let(:user) { create(:user) }

  it "is successful with valid content", :js => true do
    sign_in user, password: 'beans'
    create_organization

    expect(page).to have_content("BCN")
    expect(page).to have_content('Organization created.')

    find('.edit-organization').click
    click_link "Delete"
    sleep(0.5)
    click_button 'Ok'

    visit('/organizations')

    expect(page).to_not have_content('Organization deleted.')
    expect(Organization.count).to eq(0)
  end

  it "is successful with valid content and appropriate log", :js => true do
    sign_in user, password: 'beans'
    create_organization

    find('.edit-organization').click
    click_link "Delete"
    sleep(0.5)
    click_button 'Ok'


    del_organization = Organization.only_deleted.last

    expect(del_organization.deleted?).to eq(true)
    expect(del_organization.deleted_at).to_not eq(nil)
  end

  it 'will not allow non-creator user to delete organization', :js => true do
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