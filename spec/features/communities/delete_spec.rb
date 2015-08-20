require 'rails_helper'

describe "Delete communities" do
  let(:user) { create(:user, role: 'admin') }

  before do
    Role.create(user: user, name: 'admin')
  end

  it "is successful with valid content", :js => true do
    sign_in user, password: 'beans'
    create_community

    expect(page).to have_content("Boone Community Network")
    expect(page).to have_content('Community was successfully created.')

    find('.edit-community').click
    click_link "Delete"
    sleep(0.5)
    click_button 'Ok'

    visit('/communities')

    expect(page).to_not have_content('Community was successfully deleted.')
    expect(Community.count).to eq(0)
  end

  it "is successful with valid content and appropriate log", :js => true do
    sign_in user, password: 'beans'
    create_community

    find('.edit-community').click
    click_link "Delete"
    sleep(0.5)
    click_button 'Ok'


    del_community = Community.only_deleted.last

    expect(del_community.deleted?).to eq(true)
    expect(del_community.deleted_at).to_not eq(nil)
  end

  it 'will not allow non-creator user to delete community', :js => true do
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