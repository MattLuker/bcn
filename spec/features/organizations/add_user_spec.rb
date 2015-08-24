require 'rails_helper'

describe "Adding User to organizations" do
  let(:user) { create(:user) }
  let(:organization) { Organization.create(name: 'BCN', description: 'BCN Rulez!', color: '#eeeeee', slug: 'bcn')}

  before do
    Role.create(name: 'admin', user: user)
    Role.create(name: 'leader', user: user, organization: organization)
  end

  it "sends join request email to organization leader", :js => true do
    sign_in user, password: 'beans'
    create_organization
    expect(page).to have_content("BCN Rulez!")
    organization = Organization.last
    click_link 'Log Out'

    cheese = User.create(email: 'cheese@thehoick.com', password: 'beans')
    sign_in cheese, password: 'beans'

    visit '/organizations/' + organization.slug
    click_button 'Join ' + organization.name

    open_email(user.email)
    expect(current_email.body).to have_content("A user has requested membership in #{organization.name}.")
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

    open_email(user.email)
    expect(current_email.body).to have_content("A user has requested membership in #{organization.name}.")

    click_link 'Log Out'
    sign_in user, password: 'beans'
    visit '/organizations/' + organization.slug
    find('.edit-organization').click

    click_link 'Members'
    find('.role_' + user.id.to_s).find(:xpath, 'option[1]').select_option
    find('.update_' + user.id.to_s).click


    expect(page).to have_content("Member status updated.")
    expect(organization.users.count).to eq(2)

    open_email(cheese.email)
    expect(current_email.body).to have_content("Your membership in #{organization.nam} has been granted.")
  end
end