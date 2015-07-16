require 'rails_helper'

describe "Adding User to organizations" do
  let(:user) { create(:user) }

  it "is successful with valid content", :js => true do
    sign_in user, password: 'beans'
    create_organization
    expect(page).to have_content("BCN Rulez!")
    organization = Organization.last

    click_link 'Log Out'

    cheese = User.create(email: 'cheese@thehoick.com', password: 'beans')
    sign_in cheese, password: 'beans'

    visit '/organizations/' + organization.slug
    click_button 'Join ' + organization.name

    expect(page).to have_content("You are now part of #{organization.name}.")
    expect(organization.users.count).to eq(2)
  end

  it 'sends notification to the leader when a user joins', :js => true do
    sign_in user, password: 'beans'
    create_organization
    expect(page).to have_content("BCN Rulez!")
    organization = Organization.last

    click_link 'Log Out'

    cheese = User.create(email: 'cheese@thehoick.com', password: 'beans')
    sign_in cheese, password: 'beans'

    visit '/organizations/' + organization.slug
    click_button 'Join ' + organization.name

    expect(page).to have_content("You are now part of #{organization.name}.")
    expect(organization.users.count).to eq(2)

    open_email(user.email)
    expect(current_email.body).to have_content("A new user has joined #{organization.name}.")
  end
end