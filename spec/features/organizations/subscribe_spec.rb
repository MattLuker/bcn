require 'rails_helper'

describe 'Subscribing to Organization' do
  let(:user) { create(:user, notify_instant: true) }
  let(:user2) { create(:user, notify_instant: true) }

  let!(:post) { Post.create(title: "Great Post", description: "Great job!") }

  it 'subscribes user to organization', :js => true do
    sign_in user, password: 'beans'
    create_organization
    organization = Organization.last

    click_link 'Log Out'
    sign_in user2, password: 'beans'

    visit "/organizations/#{organization.slug}"
    #sleep(5)

    expect(page).to have_content('BCN')

    find('.organization-subscribe').click
    sleep(0.3)

    expect(organization.subscribers[0].user).to eq(user2)
  end

  it 'unsubscribes user from organization', :js => true do
    sign_in user, password: 'beans'
    create_organization
    organization = Organization.last

    click_link 'Log Out'
    sign_in user2, password: 'beans'

    visit "/organizations/#{organization.slug}"
    #sleep(5)

    expect(page).to have_content('BCN')

    find('.organization-subscribe').click
    sleep(0.3)
    expect(organization.subscribers[0].user).to eq(user2)

    find('.organization-subscribe').click
    sleep(0.3)
    expect(organization.subscribers.count).to eq(0)
  end

  it 'send email to subscribers when new post is created', :js => true do
    sign_in user, password: 'beans'
    create_organization
    organization = Organization.last

    click_link 'Log Out'
    sign_in user2, password: 'beans'

    visit "/organizations/#{organization.slug}"
    #sleep(5)

    expect(page).to have_content('BCN')
    expect(page).to have_content('BCN Rulez!')

    find('.organization-subscribe').click
    sleep(0.3)
    expect(organization.subscribers[0].user).to eq(user2)

    click_link 'Log Out'
    sign_in user, password: 'beans'

    visit '/posts'
    click_link 'New Post'
    expect(page).to have_content('New Post')

    fill_in "Title", with: 'My Location Post'
    page.execute_script("window.post_editor.codemirror.setValue('Great new post.')")

    find('#post_organization_id').find(:xpath, 'option[2]').select_option

    click_button 'Save Post'
    sleep(1)

    expect(page).to have_content('Great new post.')
    open_email(user2.email)
    expect(current_email.body).to have_content('Great new post')
  end
end