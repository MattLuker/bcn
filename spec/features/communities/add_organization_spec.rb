require 'rails_helper'

describe "Adding Organization to communities" do
  let(:user) { create(:user) }
  let(:community) { Community.create(name: 'BCN', description: 'Boone Rulez!', created_by: user.id)}

  it "is successful with valid content", :js => true do
    sign_in user, password: 'beans'

    create_organization
    expect(page).to have_content('BCN Rulez!')
    organization = Organization.last

    click_link 'Log Out'

    cheese = User.create(email: 'cheese@thehoick.com', password: 'beans')
    sign_in cheese, password: 'beans'

    visit '/organizations/' + organization.slug
    click_button 'Join ' + organization.name

    visit '/communities/' + community.slug
    click_button 'Join ' + community.name
    click_link 'as BCN'

    expect(page).to have_content("#{organization.name} is now part of #{community.name}.")
    expect(community.organizations.count).to eq(1)
  end
end