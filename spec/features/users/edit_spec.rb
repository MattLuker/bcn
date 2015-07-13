require 'rails_helper'

describe 'Editing User' do
  let(:user) { create(:user) }

  it 'requires login to edit user profile page' do
    visit "/users/#{user.id}/edit"
    expect(page).to have_content('You must be logged in to view that page.')
  end

  it 'allow edit if logged in and current_user' do
    sign_in user, password: 'beans'
    visit "/users/#{user.id}/edit"
    expect(find_field('Last name').value).to eq('Slidell')

    fill_in 'Last name', with: 'Barker'
    fill_in 'Username', with: 'bob_barker'
    click_button 'Update Profile'

    expect(page).to have_content('Name: Bob Barker')
  end

  it 'will not allow non-current user to update user profile' do
    new_user = User.create({email: 'bob@thehoick.com', password: 'beans'})
    sign_in new_user, password: 'beans'

    visit "/users/#{user.id}/edit"

    expect(page).to have_content('You can only update your profile.')
  end

  it 'will upload profile image file' do
    FileUtils.rm_rf(Rails.root.join('public', 'system', 'test'))
    file_count = Dir[Rails.root.join('public', 'system', '**', '*')].length

    sign_in user, password: 'beans'
    visit "/users/#{user.id}/edit"
    expect(find_field('Last name').value).to eq('Slidell')

    attach_file('user[photo]', Rails.root.join('app/assets/images/test_avatar.jpg'))
    click_button 'Update Profile'

    new_file_count = Dir[Rails.root.join('public', 'system', '**', '*')].length
    user.reload

    expect(user.photo.name).to eq('test_avatar.jpg')
    expect(file_count).to be < new_file_count
  end

  it 'will update web link and place link in icon' do
    sign_in user, password: 'beans'
    visit "/users/#{user.id}/edit"
    expect(find_field('Last name').value).to eq('Slidell')

    fill_in 'Web link', with: 'http://devblog.boonecommunitynetwork.com'
    click_button 'Update Profile'

    user.reload
    expect(user.web_link).to eq('http://devblog.boonecommunitynetwork.com')
    expect(find('.web-link')[:href]).to eq('http://devblog.boonecommunitynetwork.com')
  end

  it 'updates the bio field with markdown', :js => true do
    sign_in user, password: 'beans'
    visit "/users/#{user.id}/edit"
    expect(find_field('Last name').value).to eq('Slidell')

    page.execute_script("window.bio_editor.codemirror.setValue('\## Wee')")
    click_button 'Update Profile'

    expect(page).to have_css('h2', text: 'Wee')
  end
end