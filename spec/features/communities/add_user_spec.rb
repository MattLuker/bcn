require 'rails_helper'

describe "Adding User to communities" do
  let(:user) { create(:user) }
  let(:community) { Community.create(name: 'BCN', description: 'Boone Rulez!', created_by: user.id)}

  it "is successful with valid content", :js => true do
    sign_in user, password: 'beans'

    click_link 'Log Out'

    cheese = User.create(email: 'cheese@thehoick.com', password: 'beans')
    sign_in cheese, password: 'beans'

    visit '/communities/' + community.slug
    click_button 'Join ' + community.name
    click_link 'as Me'

    sleep(5)
    expect(page).to have_content("You are now part of the #{community.name} community.")
    expect(community.users.count).to eq(1)
  end
end