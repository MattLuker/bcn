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
end