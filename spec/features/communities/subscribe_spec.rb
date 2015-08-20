require 'rails_helper'

describe 'Subscribing to Community' do
  let(:user) { create(:user, role: 'admin') }
  let(:user2) { create(:user) }

  let!(:post) { Post.create(title: "Great Post", description: "Great job!") }

  before do
    Role.create(user: user, name: 'admin')
  end

  it 'subscribes user to community', :js => true do
    sign_in user, password: 'beans'
    create_community
    community = Community.last

    click_link 'Log Out'
    sign_in user2, password: 'beans'

    visit "/communities/#{community.slug}"
    #sleep(5)

    expect(page).to have_content('Boone Community Network')

    find('.community-subscribe').click
    sleep(0.3)

    expect(community.subscribers[0].user).to eq(user2)
  end

  it 'unsubscribes user from community', :js => true do
    sign_in user, password: 'beans'
    create_community
    community = Community.last

    click_link 'Log Out'
    sign_in user2, password: 'beans'

    visit "/communities/#{community.slug}"
    #sleep(5)

    expect(page).to have_content('Boone Community Network')

    find('.community-subscribe').click
    sleep(0.3)
    expect(community.subscribers[0].user).to eq(user2)

    find('.community-subscribe').click
    sleep(0.3)
    expect(community.subscribers.count).to eq(0)
  end

  it 'send email to subscribers when new post is created if notify_instant is true', :js => true do
    sign_in user, password: 'beans'
    create_community
    community = Community.last

    click_link 'Log Out'
    sign_in user2, password: 'beans'
    user2.notify_instant = true
    user2.save

    visit "/communities/#{community.slug}"
    #sleep(5)

    expect(page).to have_content('Boone Community Network')
    expect(page).to have_content('We are all part of the Boone community!')

    find('.community-subscribe').click
    sleep(0.3)
    expect(community.subscribers[0].user).to eq(user2)

    click_link 'Log Out'
    sign_in user, password: 'beans'

    visit "/posts"
    click_link "New Post"
    expect(page).to have_content("New Post")

    fill_in "Title", with: "My Location Post"
    page.execute_script("window.post_editor.codemirror.setValue('Great new post.')")

    communites_field = find('input.default')
    communites_field.set('Boone Community Network')
    communites_field.native.send_key(:Enter)

    click_button "Save Post"
    sleep(1)

    expect(page).to have_content("Great new post.")
    open_email(user2.email)
    expect(current_email.body).to have_content('Great new post')
  end

  it 'does not send email to subscribers when new post is created if notify_instant is false', :js => true do
    sign_in user, password: 'beans'
    create_community
    community = Community.last

    click_link 'Log Out'
    sign_in user2, password: 'beans'

    visit "/communities/#{community.slug}"
    #sleep(5)

    expect(page).to have_content('Boone Community Network')
    expect(page).to have_content('We are all part of the Boone community!')

    find('.community-subscribe').click
    sleep(0.3)
    expect(community.subscribers[0].user).to eq(user2)

    click_link 'Log Out'
    sign_in user, password: 'beans'

    visit "/posts"
    click_link "New Post"
    expect(page).to have_content("New Post")

    fill_in "Title", with: "My Location Post"
    page.execute_script("window.post_editor.codemirror.setValue('Great new post.')")

    communites_field = find('input.default')
    communites_field.set('Boone Community Network')
    communites_field.native.send_key(:Enter)

    expect {
      click_button "Save Post"
    }.to change{ ActionMailer::Base.deliveries.size }.by(0)
  end
end