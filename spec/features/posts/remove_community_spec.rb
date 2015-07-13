require 'rails_helper'

describe 'Creating posts' do
  let(:user) { create(:user) }

  it 'removes a community from the post', :js => true do
    sign_in user, password: 'beans'
    create_community
    expect(page).to have_content('Community was successfully created.')
    community = Community.last

    visit '/posts/new'
    expect(page).to have_content('New Post')

    fill_in 'Title', with: 'My Location Post'
    page.execute_script("window.post_editor.codemirror.setValue('Great new post.')")

    communites_field = find('input.default')
    communites_field.set('Boone Community Network')
    communites_field.native.send_key(:Enter)
    click_button 'Save Post'

    expect(page).to have_content('Great new post.')

    find('.post-edit').click
    communites_field = find('.chosen-choices')
    communites_field.click
    #communites_field.set('Boone Community Network')
    communites_field.native.send_key(:Delete)
    click_button 'Save Post'

    expect(page).to have_content("Post was successfully updated.")
  end

  it 'removes a community from the post and the community posts_count is decremented' do
    pending "Need to figure out a better way to track the count, but might not make a difference with the coming changes."

    sign_in user, password: 'beans'
    create_community
    expect(page).to have_content('Community was successfully created.')
    community = Community.last

    visit '/posts'
    click_link 'New Post'
    expect(page).to have_content('New Post')

    fill_in 'Title', with: 'My Location Post'
    fill_in "What's happening?", with: 'Great new post.'

    fill_in 'Communities (in a comma separated list)', with: 'Boone Community Network'
    click_button 'Save Post'

    expect(page).to have_content('Great new post.')

    find('.post-edit').click
    fill_in 'Communities (in a comma separated list)', with: ''
    click_button 'Save Post'

    expect(page).to have_content("Post was successfully updated.")

    community.reload
    expect(community.posts_count).to eq(0)
  end
end