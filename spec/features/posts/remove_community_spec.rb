require 'rails_helper'

describe 'Creating posts' do
  let(:user) { create(:user) }

  it 'removes a community from the post', :js => true do
    admin = User.create({ :email => 'bill@thehoick.com', :password => 'beans' })
    Role.create(name: 'admin', user: admin)
    sign_in admin, password: 'beans'
    create_community
    expect(page).to have_content('Community was successfully created.')
    community = Community.last

    visit '/posts/new'
    expect(page).to have_content('New Post')

    fill_in 'Title', with: 'My Location Post'
    page.execute_script("window.post_editor.codemirror.setValue('Great new post.')")

    communites_field = find('input.default')
    communites_field.set('Boone Community Network')
    #communites_field.native.send_key(:Enter)
    communites_field.native.send_key :return
    click_button 'Save Post'

    expect(page).to have_content('Great new post.')

    find('.post-edit-link').click
    sleep(0.3)
    communites_field = find('.chosen-choices')
    communites_field.click
    #communites_field.set('Boone Community Network')
    communites_field.native.send_key(:Delete)
    click_button 'Save Post'

    expect(page).to have_content("Post was successfully updated.")
  end
end