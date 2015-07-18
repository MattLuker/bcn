require 'rails_helper'

describe "Adding Organization to communities" do
  let(:user) { create(:user) }

  it "is successful with valid content", :js => true do
    sign_in user, password: 'beans'
    create_community
    expect(page).to have_content("We're all part of the Boone community!")
    community = Community.last

    create_organization
    expect(page).to have_content('BCN Rulez!')

    click_link 'Log Out'

    cheese = User.create(email: 'cheese@thehoick.com', password: 'beans')
    sign_in cheese, password: 'beans'

    visit '/communities/' + community.slug
    click_button 'Join ' + community.name

    expect(page).to have_content("You are now part of the #{community.name} community.")
    expect(community.organizations.count).to eq(1)
  end
end