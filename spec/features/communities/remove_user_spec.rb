require 'rails_helper'

describe "Removing User from communities" do
  let(:user) { create(:user, role: 'admin') }

  it "is successful with valid content", :js => true do
    sign_in user, password: 'beans'
    create_community
    community = Community.last

    click_link 'Log Out'

    cheese = User.create(email: 'cheese@thehoick.com', password: 'beans', first_name: 'Cheese', last_name: 'Cheeese')
    sign_in cheese, password: 'beans'

    visit '/communities/' + community.slug
    click_button 'Join ' + community.name
    click_link 'as Me'

    expect(page).to have_content("You are now part of the #{community.name} community.")
    expect(community.users.count).to eq(2)
    expect(community.users_count).to eq(1)

    visit('/users/' + cheese.id.to_s)
    find('.communities-tab').click
    find('.leave-community').click
    sleep(0.5)
    click_button 'Yes, Leave!'

    expect(page).to have_content("You have left the #{community.name} community.")
    expect(community.users_count).to eq(1)
  end
end