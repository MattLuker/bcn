require 'rails_helper'

describe "Removing User from organizations" do
  let(:user) { create(:user, notify_instant: true) }
  let(:organization) { Organization.create(name: 'BCN', description: 'BCN Rulez!', color: '#eeeeee', slug: 'bcn')}

  before do
    Role.create(name: 'admin', user: user)
    Role.create(name: 'leader', user: user, organization: organization)
  end

  it 'organization leader can remove user', :js => true do
    sign_in user, password: 'beans'
    create_organization
    expect(page).to have_content("BCN Rulez!")
    organization = Organization.last
    click_link 'Log Out'

    cheese = User.create(email: 'cheese@thehoick.com', password: 'beans', notify_instant: true)
    sign_in cheese, password: 'beans'

    visit '/organizations/' + organization.slug
    click_button 'Join ' + organization.name

    open_email(user.email)
    expect(current_email.body).to have_content("A user has requested membership in #{organization.name}.")

    click_link 'Log Out'
    sign_in user, password: 'beans'
    visit '/organizations/' + organization.slug
    find('.edit-organization').click

    click_link 'Members'
    find('.role_' + cheese.id.to_s).find(:xpath, 'option[3]').select_option
    find('.update_' + cheese.id.to_s).click

    expect(page).to have_content("Member status updated.")
    expect(organization.users.count).to eq(2)

    open_email(cheese.email)
    expect(current_email.body).to have_content("Your membership in #{organization.name} has been granted.")

    click_link 'Log Out'
    sign_in user, password: 'beans'
    visit '/organizations/' + organization.slug
    find('.edit-organization').click

    click_link 'Members'
    find('.role_' + cheese.id.to_s).find(:xpath, 'option[4]').select_option
    find('.update_' + cheese.id.to_s).click

    expect(page).to have_content("Member status updated.")
    expect(organization.users.count).to eq(1)
  end

  it 'user can leave organization', :js => true do
    sign_in user, password: 'beans'
    create_organization
    expect(page).to have_content("BCN Rulez!")
    organization = Organization.last
    click_link 'Log Out'

    cheese = User.create(email: 'cheese@thehoick.com', password: 'beans', notify_instant: true)
    sign_in cheese, password: 'beans'

    visit '/organizations/' + organization.slug
    click_button 'Join ' + organization.name

    open_email(user.email)
    expect(current_email.body).to have_content("A user has requested membership in #{organization.name}.")

    click_link 'Log Out'
    sign_in user, password: 'beans'
    visit '/organizations/' + organization.slug
    find('.edit-organization').click

    click_link 'Members'
    find('.role_' + cheese.id.to_s).find(:xpath, 'option[3]').select_option
    find('.update_' + cheese.id.to_s).click

    expect(page).to have_content("Member status updated.")
    expect(organization.users.count).to eq(2)

    open_email(cheese.email)
    expect(current_email.body).to have_content("Your membership in #{organization.name} has been granted.")

    click_link 'Log Out'
    sign_in cheese, password: 'beans'
    visit "/users/#{cheese.id}"
    find('.organizations-tab').click

    find('.leave-organization').click
    sleep(1)
    click_button 'Yes'

    expect(page).to have_content("You have left #{organization.name}.")
    expect(organization.users.count).to eq(1)
  end
end