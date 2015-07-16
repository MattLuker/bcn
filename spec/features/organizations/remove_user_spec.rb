require 'rails_helper'

describe "Removing User from organizations" do
  let(:user) { create(:user) }

  it "is successful with valid content", :js => true do
    sign_in user, password: 'beans'
    create_organization
    organization = Organization.last

    click_link 'Log Out'

    cheese = User.create(email: 'cheese@thehoick.com', password: 'beans', first_name: 'Cheese', last_name: 'Cheeese')
    sign_in cheese, password: 'beans'

    visit '/organizations/' + organization.slug
    click_button 'Join ' + organization.name

    expect(page).to have_content("You are now part of #{organization.name}.")
    expect(organization.users.count).to eq(2)

    visit('/users/' + cheese.id.to_s)
    find('.organizations-tab').click
    find('.leave-organization').click
    sleep(0.5)
    click_button 'Yes, Leave!'

    expect(page).to have_content("You have left #{organization.name}.")
    expect(organization.users.count).to eq(1)
  end
end