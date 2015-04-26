require 'rails_helper'

describe "Adding User to communities" do
  let(:user) { create(:user) }

  it "is successful with valid content" do
    sign_in user, password: 'beans'
    create_community
    expect(page).to have_content("We're all part of the Boone community!")
    community = Community.last

    click_link 'Log Out'

    cheese = User.create(email: 'cheese@thehoick.com', password: 'beans')
    sign_in cheese, password: 'beans'

    visit '/communities/' + community.id.to_s
    click_button 'Join Community'

    expect(page).to have_content("You are now part of the #{community.name} community.")
    expect(community.users.count).to eq(2)
  end
end