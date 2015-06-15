require 'rails_helper'

describe 'Deleting User' do
  let(:user) { create(:user) }

  it 'requires login to edit user profile page' do
    visit "/users/#{user.id}"
    expect(page).to have_content('You must be logged in to view that page.')
  end

  it 'allow delete if logged in and current user' do
    sign_in user, password: 'beans'
    expect(User.count).to eq(1)

    visit "/users/#{user.id}"
    expect(page).to have_content('Name: Bob Slidell')
    find('.edit-profile').click
    click_link 'Delete Account'

    expect(User.count).to eq(0)
  end

  it 'will not let non-current user delete other users' do
    new_user = User.create({email: 'bob@thehoick.com', password: 'beans'})
    sign_in(new_user, {password: 'beans'})

    visit "/users/#{user.id}"
    expect(page).to_not have_css('.edit-profile')
    expect(User.count).to eq(2)
  end

end